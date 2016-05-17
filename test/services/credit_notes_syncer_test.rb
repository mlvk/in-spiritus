require 'test_helper'

class CreditNotesSyncerTest < ActiveSupport::TestCase

  # Local sync testing
  test "Remote voided credit_notes should update to voided locally" do
    credit_note = create(:credit_note_with_credit_note_items, :synced)
    credit_note.mark_submitted!

    yaml_props = {
      credit_note_id: credit_note.xero_id,
      credit_note_number: credit_note.credit_note_number,
      remote_credit_note_status: 'VOIDED'
    }

    VCR.use_cassette('credit_notes/007', erb: yaml_props) do
      CreditNotesSyncer.new.sync_local
    end

    credit_note.reload

    assert credit_note.voided?, 'Should have been voided'
  end

  test "Remote deleted credit_notes should update to voided locally" do
    credit_note = create(:credit_note_with_credit_note_items, :synced)
    credit_note.mark_submitted!

    yaml_props = {
      credit_note_id: credit_note.xero_id,
      credit_note_number: credit_note.credit_note_number,
      remote_credit_note_status: 'DELETED'
    }

    VCR.use_cassette('credit_notes/007', erb: yaml_props) do
      CreditNotesSyncer.new.sync_local
    end

    credit_note.reload

    assert credit_note.voided?, 'Should have been deleted'
  end

  test "Valid local credit_notes should be created in xero" do
    credit_note = create(:credit_note_with_credit_note_items, :submitted)

    yaml_props = {
      remote_credit_note_id: 'new_credit_note_id',
      credit_note_number: credit_note.credit_note_number,
      credit_note_items: credit_note.credit_note_items
    }

    VCR.use_cassette('credit_notes/002',  erb: yaml_props) do
      CreditNotesSyncer.new.sync_local
    end

    credit_note.reload

    assert credit_note.xero_id.present?, 'Xero id not present'
    assert credit_note.synced?, 'credit_note was not marked as synced'
  end

  # Remote testing
  test "should not create a local credit_note if credit_number not found locally" do
    assert CreditNote.all.empty?

    VCR.use_cassette('credit_notes/003') do
      CreditNotesSyncer.new.sync_remote
    end

    assert CreditNote.all.empty?
  end

  test "should update a local credit when remote/local are out of sync and local model is in state synced" do
    credit_note = create(:credit_note_with_credit_note_items, :synced, quantity:7)

    yaml_props = {
      remote_credit_note_id: 'new_credit_note_id',
      remote_credit_note_number: credit_note.credit_note_number,
      remote_quantity: 10,
      credit_note_items: credit_note.credit_note_items
    }

    VCR.use_cassette('credit_notes/004', erb: yaml_props) do
      CreditNotesSyncer.new.sync_remote(10.minutes.ago)
    end

    credit_note.reload

    assert credit_note.credit_note_items.all? {|credit_note_item| credit_note_item.quantity == yaml_props[:quantity]}, 'Credit_note_items quantities did not match'
  end

  test "should remove credit_note_item if missing from remote record and local model is synced?" do
    credit_note = create(:credit_note_with_credit_note_items, :synced)

    yaml_props = {
      remote_credit_note_id: 'new_credit_note_id',
      remote_credit_note_number: credit_note.credit_note_number,
      credit_note_items: []
    }

    VCR.use_cassette('credit_notes/004', erb: yaml_props) do
      CreditNotesSyncer.new.sync_remote(10.minutes.ago)
    end

    credit_note.reload

    assert credit_note.credit_note_items.empty?, 'Credit note items found when expected none'
  end

  test "should not create new credit note when credit total is 0" do
    credit_note = create(:credit_note_with_credit_note_items, :submitted, unit_price:0, quantity:5)

    syncer = CreditNotesSyncer.new

    prepare_record_spy = Spy.on(syncer, :prepare_record)
    syncer.sync_local

    refute prepare_record_spy.has_been_called?, 'Should not have been prepared'
  end

  test "should create new credit note when credit total is greater than 0" do
    credit_note = create(:credit_note_with_credit_note_items, :submitted, unit_price:10, quantity:5)

    syncer = CreditNotesSyncer.new

    prepare_record_spy = Spy.on(syncer, :prepare_record)
    syncer.sync_local

    assert prepare_record_spy.has_been_called?, 'Should have been prepared'
  end

  test "should only sync items with quanity and unit_price greater than 0" do

    credit_note = create(:credit_note, :submitted)

    valid_credit_note_items = [create(:credit_note_item, credit_note: credit_note)]

    invalid_credit_note_items = [
      create(:credit_note_item, quantity: 0, unit_price: 0, credit_note: credit_note),
      create(:credit_note_item, quantity: 0, unit_price: 10, credit_note: credit_note)
    ]

    all_credit_note_items = valid_credit_note_items.concat invalid_credit_note_items

    credit_note.reload

    assert_equal(all_credit_note_items.count, credit_note.credit_note_items.count, 'Incorrect number of starting credit_note_items for test');

    syncer = CreditNotesSyncer.new

    update_record_spy = Spy.on(syncer, :update_record).and_call_through

    yaml_props = {
      remote_credit_note_id: 'new_credit_note_id',
      credit_note_number: credit_note.credit_note_number,
      credit_note_items: valid_credit_note_items
    }

    VCR.use_cassette('credit_notes/002', erb: yaml_props) do
      syncer.sync_local
    end

    first_call = update_record_spy.calls.first

    assert_equal(1, first_call.result.count, 'Wrong number of credit note items created');
    assert_equal(valid_credit_note_items.first, first_call.result.first, 'The wrong credit note was created');
  end

end
