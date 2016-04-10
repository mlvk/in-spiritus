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

end
