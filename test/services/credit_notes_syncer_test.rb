require 'test_helper'

class CreditNotesSyncerTest < ActiveSupport::TestCase

  # Not using due to xero lineitemid issue
  # test "Remote voided credit_notes should update to voided locally when in state authorized locally" do
  #   credit_note = create(:credit_note_with_credit_note_items, :with_xero_id)
  #   credit_note.mark_authorized!
  #
  #   yaml_props = {
  #     id: credit_note.xero_id,
  #     number: credit_note.credit_note_number,
  #     status: 'VOIDED'
  #   }
  #
  #   VCR.use_cassette('credit_notes/query_credit_note_by_id', :erb => yaml_props, :match_requests_on => [:host]) do
  #     CreditNotesSyncer.new.sync_local
  #   end
  #
  #   credit_note.reload
  #
  #   assert credit_note.voided?, 'Should have been voided'
  # end

  # Not using due to xero lineitemid issue
  # test "Remote deleted credit_notes should update to deleted locally" do
  #   credit_note = create(:credit_note_with_credit_note_items, :with_xero_id, :submitted)
  #
  #   yaml_props = {
  #     id: credit_note.xero_id,
  #     number: credit_note.credit_note_number,
  #     status: 'DELETED'
  #   }
  #
  #   VCR.use_cassette('credit_notes/query_credit_note_by_id', :erb => yaml_props) do
  #     CreditNotesSyncer.new.sync_local
  #   end
  #
  #   credit_note.reload
  #
  #   assert credit_note.deleted?, 'Should have been deleted'
  # end

  test "Valid local credit_notes should be created in xero" do
    credit_note = create(:credit_note_with_credit_note_items, :submitted)

    yaml_props = {
      remote_credit_note_id: 'new_credit_note_id',
      credit_note_number: credit_note.credit_note_number,
      credit_note_items: credit_note.credit_note_items
    }

    VCR.use_cassette('credit_notes/query_not_found_create', erb: yaml_props) do
      CreditNotesSyncer.new.sync_local
    end

    credit_note.reload

    assert credit_note.has_synced_with_xero?, 'Should have synced with xero'
    assert credit_note.synced?, 'credit_note was not marked as synced'
  end

  # Remote testing
  # Not using due to xero lineitemid issue
  # test "should not create a local credit_note if credit_number not found locally" do
  #   assert CreditNote.all.empty?
  #
  #   VCR.use_cassette('credit_notes/003') do
  #     CreditNotesSyncer.new.sync_remote(10.minutes.from_now)
  #   end
  #
  #   assert CreditNote.all.empty?
  # end
  #
  # test "should update a local credit when remote/local are out of sync and local model is in state synced" do
  #   credit_note = create(:credit_note_with_credit_note_items, quantity:7)
  #
  #   credit_note.mark_synced!
  #
  #   yaml_props = {
  #     remote_credit_note_id: 'new_credit_note_id',
  #     remote_credit_note_number: credit_note.credit_note_number,
  #     remote_quantity: 10,
  #     credit_note_items: credit_note.credit_note_items,
  #     updated_date_utc: 10.minutes.from_now
  #   }
  #
  #   VCR.use_cassette('credit_notes/query_remote_changed_query_record_match_force_remote_quantity', erb: yaml_props) do
  #     CreditNotesSyncer.new.sync_remote(10.minutes.from_now)
  #   end
  #
  #   credit_note.reload
  #
  #   assert credit_note.credit_note_items.all? {|credit_note_item| credit_note_item.quantity == yaml_props[:remote_quantity]}, 'Credit_note_items quantities did not match'
  # end

  # Not using due to xero lineitemid issue
  # test "should remove credit_note_item if missing from remote record and local model is synced?" do
  #   credit_note = create(:credit_note_with_credit_note_items)
  #
  #   credit_note.mark_synced!
  #
  #   yaml_props = {
  #     remote_credit_note_id: 'new_credit_note_id',
  #     remote_credit_note_number: credit_note.credit_note_number,
  #     credit_note_items: [],
  #     updated_date_utc: 10.minutes.from_now
  #   }
  #
  #   VCR.use_cassette('credit_notes/query_remote_changed_query_record_match', erb: yaml_props) do
  #     CreditNotesSyncer.new.sync_remote(10.minutes.from_now)
  #   end
  #
  #   credit_note.reload
  #
  #   assert credit_note.credit_note_items.empty?, 'Credit note items found when expected none'
  # end

  # test "should not remove credit_note_item if present in remote record and local model is synced?" do
  #   credit_note = create(:credit_note_with_credit_note_items, :with_xero_id)
  #   count = credit_note.credit_note_items.count
  #   credit_note.mark_synced!
  #
  #   yaml_props = {
  #     remote_credit_note_id: credit_note.xero_id,
  #     remote_credit_note_number: credit_note.credit_note_number,
  #     credit_note_items: credit_note.credit_note_items,
  #     updated_date_utc: 10.minutes.from_now
  #   }
  #
  #   VCR.use_cassette('credit_notes/query_remote_changed_query_record_match', erb: yaml_props) do
  #     CreditNotesSyncer.new.sync_remote(10.minutes.from_now)
  #   end
  #
  #   credit_note.reload
  #
  #   assert_equal(count, credit_note.credit_note_items.count, 'Credit note items count was not correct')
  # end

  test "should still create new credit note when credit total is 0" do
    credit_note = create(:credit_note_with_credit_note_items, :submitted, unit_price:0, quantity:5)

    syncer = CreditNotesSyncer.new

    should_save_record_spy = Spy.on(syncer, :should_save_record?).and_call_through

    yaml_props = {
      credit_note_number: credit_note.credit_note_number
    }

    VCR.use_cassette('credit_notes/query_no_result', erb: yaml_props) do
      syncer.sync_local
    end

    first_call = should_save_record_spy.calls.first

    assert first_call.result, 'Should have returned true for should_save_record?'
  end

  test "should create new credit note when credit total is greater than 0" do
    credit_note = create(:credit_note_with_credit_note_items, :submitted, unit_price:10, quantity:5)

    yaml_props = {
      remote_credit_note_id: 'new_credit_note_id',
      credit_note_number: credit_note.credit_note_number,
      credit_note_items: credit_note.credit_note_items
    }

    syncer = CreditNotesSyncer.new

    should_save_record_spy = Spy.on(syncer, :should_save_record?).and_call_through

    VCR.use_cassette('credit_notes/query_not_found_create', erb: yaml_props) do
      syncer.sync_local
    end

    first_call = should_save_record_spy.calls.first

    credit_note.reload

    assert first_call.result, 'Should have returned true for should_save_record?'
    assert credit_note.has_synced_with_xero?, 'Should have synced with xero'
    assert credit_note.synced?, 'Should be in synced state'
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

    VCR.use_cassette('credit_notes/query_not_found_create', erb: yaml_props) do
      syncer.sync_local
    end

    first_call = update_record_spy.calls.first

    assert_equal(1, first_call.result.count, 'Wrong number of credit note items created');
    assert_equal(valid_credit_note_items.first, first_call.result.first, 'The wrong credit note was created');
  end

end
