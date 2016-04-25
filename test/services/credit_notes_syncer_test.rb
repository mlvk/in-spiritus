require 'test_helper'

class CreditNotesSyncerTest < ActiveSupport::TestCase

  # Local sync testing
  test "Remote deleted credit_notes should update to voided locally" do

    Item.create(name:'Sunseed Chorizo')

    company = Company.create(name:'Nature Well')
    location = Location.create(name:'Silverlake', code:'NW001', company:company)
    credit_note = CreditNote.create(location:location, date:Date.parse('2016-03-01'))
    credit_note.credit_note_number = 'voided-credit-note-number'
    credit_note.save

    credit_note.mark_submitted!

    Item.all.each do |item|
      CreditNoteItem.create(item:item, quantity:5, unit_price:5, credit_note:credit_note)
    end

    VCR.use_cassette('credit_notes/001') do
      CreditNotesSyncer.new.sync_local
    end

    credit_note.reload

    assert credit_note.voided?, 'Should have been voided'
  end

  test "Valid local credit_notes should be created in xero" do

    Item.create(name:'Sunseed Chorizo')

    company = Company.create(name:'Nature Well')
    location = Location.create(name:'Silverlake', code:'NW001', company:company)
    credit_note = CreditNote.create(location:location, date:Date.parse('2016-03-01'))
    credit_note.credit_note_number = 'valid-new-credit-note'
    credit_note.save

    credit_note.mark_submitted!

    Item.all.each do |item|
      CreditNoteItem.create(item:item, quantity:5, unit_price:5, credit_note:credit_note)
    end

    VCR.use_cassette('credit_notes/002') do
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

    Item.create(name:'Sunseed Chorizo')

    company = Company.create(name:'Nature Well')
    location = Location.create(name:'Silverlake', code:'NW001', company:company)
    credit_note = CreditNote.create(location:location, date:Date.parse('2016-03-01'))
    credit_note.credit_note_number = 'updated-remote-credit-number'
    credit_note.xero_id = 'updated-remote-credit-note-id'
    credit_note.save

    credit_note.mark_submitted!

    Item.all.each do |item|
      CreditNoteItem.create(item:item, quantity:5, unit_price:5, credit_note:credit_note)
    end

    credit_note.mark_synced!

    VCR.use_cassette('credit_notes/004') do
      CreditNotesSyncer.new.sync_remote(10.minutes.ago)
    end

    credit_note.reload

    assert credit_note.credit_note_items.all? {|credit_note_item| credit_note_item.quantity == 6.0}, 'Credit_note_items quantities did not match'
  end

  test "should remove credit_note_item if missing from remote record and local model is synced?" do
    Item.create(name:'Sunseed Chorizo')

    company = Company.create(name:'Nature Well')
    location = Location.create(name:'Silverlake', code:'NW001', company:company)
    credit_note = CreditNote.create(location:location, date:Date.parse('2016-03-01'))
    credit_note.credit_note_number = 'remote-credit-order-with-removed-order-item-number'
    credit_note.xero_id = 'remote-credit-order-with-removed-order-item-id'
    credit_note.save

    credit_note.mark_submitted!

    Item.all.each do |item|
      CreditNoteItem.create(item:item, quantity:5, unit_price:5, credit_note:credit_note)
    end

    credit_note.mark_synced!

    VCR.use_cassette('credit_notes/005') do
      CreditNotesSyncer.new.sync_remote(10.minutes.ago)
    end

    credit_note.reload

    assert credit_note.credit_note_items.empty?, 'Credit note items found when expected none'
  end

  test "should not create new credit note when credit total is 0" do
    Item.create(name:'Sunseed Chorizo')

    company = Company.create(name:'Nature Well')
    location = Location.create(name:'Silverlake', code:'NW001', company:company)
    credit_note = CreditNote.create(location:location, date:Date.parse('2016-03-01'))

    credit_note.mark_submitted!

    Item.all.each do |item|
      CreditNoteItem.create(item:item, quantity:5, unit_price:0, credit_note:credit_note)
    end

    syncer = CreditNotesSyncer.new


    prepare_record_spy = Spy.on(syncer, :prepare_record)
    syncer.sync_local

    refute prepare_record_spy.has_been_called?, 'Should not have been prepared'
  end

  test "should create new credit note when credit total is greater than 0" do
    Item.create(name:'Sunseed Chorizo')

    company = Company.create(name:'Nature Well')
    location = Location.create(name:'Silverlake', code:'NW001', company:company)
    credit_note = CreditNote.create(location:location, date:Date.parse('2016-03-01'))

    credit_note.mark_submitted!

    Item.all.each do |item|
      CreditNoteItem.create(item:item, quantity:5, unit_price:5, credit_note:credit_note)
    end

    syncer = CreditNotesSyncer.new

    prepare_record_spy = Spy.on(syncer, :prepare_record)
    syncer.sync_local

    assert prepare_record_spy.has_been_called?, 'Should have been prepared'
  end

  test "should only sync items with quanity and unit_price greater than 0" do
    Item.create(name:'Sunseed Chorizo')

    company = Company.create(name:'Nature Well')
    location = Location.create(name:'Silverlake', code:'NW001', company:company)
    credit_note = CreditNote.create(
      credit_note_number: 'local-credit-note-with-invalid-items-id',
      location:location,
      date:Date.parse('2016-03-01'))

    credit_note.mark_submitted!

    valid_credit_note_item = CreditNoteItem.create(item:Item.first, quantity:5.0, unit_price:5.0, credit_note:credit_note)
    invalid_credit_note_item = CreditNoteItem.create(item:Item.last, quantity:5.0, unit_price:0.0, credit_note:credit_note)

    credit_note.reload

    # binding.pry

    syncer = CreditNotesSyncer.new

    update_record_spy = Spy.on(syncer, :update_record).and_call_through

    VCR.use_cassette('credit_notes/006') do
      syncer.sync_local
    end

    first_call = update_record_spy.calls.first

    assert_equal(first_call.result.count, 1, 'Wrong number of credit note items created');
    assert_equal(first_call.result.first, valid_credit_note_item, 'The wrong credit note was created');
  end

end
