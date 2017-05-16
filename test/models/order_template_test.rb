require 'test_helper'

class OrderTemplateTest < ActiveSupport::TestCase

  test "matches on dates correctly with 1 week frequency" do
    location = create(:location)

    order_template = create(:order_template, start_date:"2017-05-01", frequency:1)
    monday = create(:order_template_day, day:0, enabled:true, order_template:order_template)
    wednesday = create(:order_template_day, day:2, enabled:true, order_template:order_template)
    friday = create(:order_template_day, day:4, enabled:true, order_template:order_template)

    order_template.reload

    assert order_template.valid_for_date?(Date.parse("2017-05-01")), "2017-05-01 should have been marked for delivery"
    assert order_template.valid_for_date?(Date.parse("2017-05-03")), "2017-05-03 should have been marked for delivery"
    assert order_template.valid_for_date?(Date.parse("2017-05-05")), "2017-05-05 should have been marked for delivery"
    assert order_template.valid_for_date?(Date.parse("2017-05-08")), "2017-05-08 should have been marked for delivery"
    assert order_template.valid_for_date?(Date.parse("2017-05-10")), "2017-05-10 should have been marked for delivery"
    assert order_template.valid_for_date?(Date.parse("2017-05-12")), "2017-05-12 should have been marked for delivery"

    refute order_template.valid_for_date?(Date.parse("2017-05-02")), "2017-05-02 should not have been marked for delivery"
    refute order_template.valid_for_date?(Date.parse("2017-05-04")), "2017-05-04 should not have been marked for delivery"
    refute order_template.valid_for_date?(Date.parse("2017-05-06")), "2017-05-06 should not have been marked for delivery"
    refute order_template.valid_for_date?(Date.parse("2017-05-09")), "2017-05-09 should not have been marked for delivery"
    refute order_template.valid_for_date?(Date.parse("2017-05-11")), "2017-05-11 should not have been marked for delivery"
    refute order_template.valid_for_date?(Date.parse("2017-05-13")), "2017-05-13 should not have been marked for delivery"
  end

  test "does not match on disabled days" do
    location = create(:location)

    order_template = create(:order_template, start_date:"2017-05-01", frequency:1)
    monday = create(:order_template_day, day:0, enabled:false, order_template:order_template)
    wednesday = create(:order_template_day, day:2, enabled:false, order_template:order_template)
    friday = create(:order_template_day, day:4, enabled:false, order_template:order_template)

    order_template.reload

    refute order_template.valid_for_date?(Date.parse("2017-05-01")), "2017-05-01 should not have been marked for delivery"
    refute order_template.valid_for_date?(Date.parse("2017-05-03")), "2017-05-03 should not have been marked for delivery"
    refute order_template.valid_for_date?(Date.parse("2017-05-05")), "2017-05-05 should not have been marked for delivery"
    refute order_template.valid_for_date?(Date.parse("2017-05-08")), "2017-05-08 should not have been marked for delivery"
    refute order_template.valid_for_date?(Date.parse("2017-05-10")), "2017-05-10 should not have been marked for delivery"
    refute order_template.valid_for_date?(Date.parse("2017-05-12")), "2017-05-12 should not have been marked for delivery"
  end

  test "matches on dates correctly with 1 week frequency after two year" do
    location = create(:location)

    order_template = create(:order_template, start_date:"2015-05-01", frequency:1)
    monday = create(:order_template_day, day:0, enabled:true, order_template:order_template)
    wednesday = create(:order_template_day, day:2, enabled:true, order_template:order_template)
    friday = create(:order_template_day, day:4, enabled:true, order_template:order_template)

    order_template.reload

    assert order_template.valid_for_date?(Date.parse("2017-05-01")), "2017-05-01 should have been marked for delivery"
    assert order_template.valid_for_date?(Date.parse("2017-05-03")), "2017-05-03 should have been marked for delivery"
    assert order_template.valid_for_date?(Date.parse("2017-05-05")), "2017-05-05 should have been marked for delivery"
    assert order_template.valid_for_date?(Date.parse("2017-05-08")), "2017-05-08 should have been marked for delivery"
    assert order_template.valid_for_date?(Date.parse("2017-05-10")), "2017-05-10 should have been marked for delivery"
    assert order_template.valid_for_date?(Date.parse("2017-05-12")), "2017-05-12 should have been marked for delivery"

    refute order_template.valid_for_date?(Date.parse("2017-05-02")), "2017-05-02 should not have been marked for delivery"
    refute order_template.valid_for_date?(Date.parse("2017-05-04")), "2017-05-04 should not have been marked for delivery"
    refute order_template.valid_for_date?(Date.parse("2017-05-06")), "2017-05-06 should not have been marked for delivery"
    refute order_template.valid_for_date?(Date.parse("2017-05-09")), "2017-05-09 should not have been marked for delivery"
    refute order_template.valid_for_date?(Date.parse("2017-05-11")), "2017-05-11 should not have been marked for delivery"
    refute order_template.valid_for_date?(Date.parse("2017-05-13")), "2017-05-13 should not have been marked for delivery"
  end

  test "matches on dates correctly with 2 week frequency" do
    location = create(:location)

    order_template = create(:order_template, start_date:"2017-05-04", frequency:2)
    monday = create(:order_template_day, day:0, enabled:true, order_template:order_template)
    wednesday = create(:order_template_day, day:2, enabled:true, order_template:order_template)
    friday = create(:order_template_day, day:4, enabled:true, order_template:order_template)

    order_template.reload

    assert order_template.valid_for_date?(Date.parse("2017-05-01")), "2017-05-01 should have been marked for delivery"
    assert order_template.valid_for_date?(Date.parse("2017-05-03")), "2017-05-03 should have been marked for delivery"
    assert order_template.valid_for_date?(Date.parse("2017-05-05")), "2017-05-05 should have been marked for delivery"
    assert order_template.valid_for_date?(Date.parse("2017-05-15")), "2017-05-15 should have been marked for delivery"
    assert order_template.valid_for_date?(Date.parse("2017-05-17")), "2017-05-17 should have been marked for delivery"
    assert order_template.valid_for_date?(Date.parse("2017-05-19")), "2017-05-19 should have been marked for delivery"

    refute order_template.valid_for_date?(Date.parse("2017-05-08")), "2017-05-08 should not have been marked for delivery"
    refute order_template.valid_for_date?(Date.parse("2017-05-10")), "2017-05-10 should not have been marked for delivery"
    refute order_template.valid_for_date?(Date.parse("2017-05-12")), "2017-05-12 should not have been marked for delivery"
    refute order_template.valid_for_date?(Date.parse("2017-05-22")), "2017-05-22 should not have been marked for delivery"
    refute order_template.valid_for_date?(Date.parse("2017-05-24")), "2017-05-24 should not have been marked for delivery"
    refute order_template.valid_for_date?(Date.parse("2017-05-26")), "2017-05-26 should not have been marked for delivery"
  end

  test "matches on dates correctly with 3 week frequency" do
    location = create(:location)

    order_template = create(:order_template, start_date:"2017-05-04", frequency:3)
    monday = create(:order_template_day, day:0, enabled:true, order_template:order_template)
    wednesday = create(:order_template_day, day:2, enabled:true, order_template:order_template)
    friday = create(:order_template_day, day:4, enabled:true, order_template:order_template)

    order_template.reload

    assert order_template.valid_for_date?(Date.parse("2017-05-01")), "2017-05-01 should have been marked for delivery"
    assert order_template.valid_for_date?(Date.parse("2017-05-03")), "2017-05-03 should have been marked for delivery"
    assert order_template.valid_for_date?(Date.parse("2017-05-05")), "2017-05-05 should have been marked for delivery"
    assert order_template.valid_for_date?(Date.parse("2017-05-22")), "2017-05-22 should have been marked for delivery"
    assert order_template.valid_for_date?(Date.parse("2017-05-24")), "2017-05-24 should have been marked for delivery"
    assert order_template.valid_for_date?(Date.parse("2017-05-26")), "2017-05-26 should have been marked for delivery"

    refute order_template.valid_for_date?(Date.parse("2017-05-08")), "2017-05-08 should not have been marked for delivery"
    refute order_template.valid_for_date?(Date.parse("2017-05-10")), "2017-05-10 should not have been marked for delivery"
    refute order_template.valid_for_date?(Date.parse("2017-05-12")), "2017-05-12 should not have been marked for delivery"
    refute order_template.valid_for_date?(Date.parse("2017-05-15")), "2017-05-15 should not have been marked for delivery"
    refute order_template.valid_for_date?(Date.parse("2017-05-17")), "2017-05-17 should not have been marked for delivery"
    refute order_template.valid_for_date?(Date.parse("2017-05-19")), "2017-05-19 should not have been marked for delivery"
  end

  test "matches on dates correctly with 3 week frequency after 2 months" do
    location = create(:location)

    order_template = create(:order_template, start_date:"2017-05-04", frequency:3)
    monday = create(:order_template_day, day:0, enabled:true, order_template:order_template)
    wednesday = create(:order_template_day, day:2, enabled:true, order_template:order_template)
    friday = create(:order_template_day, day:4, enabled:true, order_template:order_template)

    order_template.reload

    assert order_template.valid_for_date?(Date.parse("2017-06-12")), "2017-06-12 should have been marked for delivery"
    assert order_template.valid_for_date?(Date.parse("2017-06-14")), "2017-06-14 should have been marked for delivery"
    assert order_template.valid_for_date?(Date.parse("2017-06-16")), "2017-06-16 should have been marked for delivery"
    assert order_template.valid_for_date?(Date.parse("2017-07-03")), "2017-07-03 should have been marked for delivery"
    assert order_template.valid_for_date?(Date.parse("2017-07-05")), "2017-07-05 should have been marked for delivery"
    assert order_template.valid_for_date?(Date.parse("2017-07-07")), "2017-07-07 should have been marked for delivery"

    refute order_template.valid_for_date?(Date.parse("2017-06-13")), "2017-06-13 should not have been marked for delivery"
    refute order_template.valid_for_date?(Date.parse("2017-06-15")), "2017-06-15 should not have been marked for delivery"
    refute order_template.valid_for_date?(Date.parse("2017-06-17")), "2017-06-17 should not have been marked for delivery"
    refute order_template.valid_for_date?(Date.parse("2017-07-04")), "2017-07-04 should not have been marked for delivery"
    refute order_template.valid_for_date?(Date.parse("2017-07-06")), "2017-07-06 should not have been marked for delivery"
    refute order_template.valid_for_date?(Date.parse("2017-07-08")), "2017-07-08 should not have been marked for delivery"
  end

  test "raises error when passed nil date" do
    location = create(:location)

    order_template = create(:order_template, start_date:"2017-05-01", frequency:1)
    monday = create(:order_template_day, day:0, enabled:false, order_template:order_template)
    wednesday = create(:order_template_day, day:2, enabled:false, order_template:order_template)
    friday = create(:order_template_day, day:4, enabled:false, order_template:order_template)

    order_template.reload
    
    assert_raises(ArgumentError) {
      order_template.valid_for_date?(nil)
    }
  end
end
