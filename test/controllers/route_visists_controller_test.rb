require 'test_helper'

class RouteVisitsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  def setup
    prep_jr_headers
  end

  def build_submit_payload(route_visit)
    {
      id: route_visit.id,
      data: {
        completed_at: "2016-11-08T23:30:11.195Z",
        fulfillments: route_visit.fulfillments.map(&method(:build_fulfillment_hash))
      }
    }
  end

  def build_fulfillment_hash(f)
    {
      id: f.id,
      order: build_order_hash(f.order),
      credit_note: build_credit_note_hash(f.credit_note),
      stock: build_stock_hash(f.stock),
      pod: build_pod_hash(f.pod)
    }
  end

  def build_order_hash(o)
    {
      id: o.id,
      order_items: o.order_items.map {|oi|
        {
          id: oi.id,
          item_id: oi.item.id,
          quantity: 99,
          unit_price: 99
        }
      }
    }
  end

  def build_credit_note_hash(cn)
    {
      id: cn.id,
      credit_note_items: cn.credit_note_items.map {|cni|
        {
          id: cni.id,
          item_id: cni.item.id,
          quantity: 99,
          unit_price: 99
        }
      }
    }
  end

  def build_stock_hash(s)
    {
      id: s.id,
      stock_levels: s.stock_levels.map {|sl|
        {
          id: sl.id,
          item_id: sl.item.id,
          starting: 99,
          returns: 99
        }
      }
    }
  end

  def build_pod_hash(pod)
    {
      id: pod.id,
      name: "Method Man",
      signature: pod.signature
    }
  end

  test "drivers can submit route_visits" do
    sign_in_as_driver

    route_visit = create(:route_visit_with_unfulfilled_fulfillments)

    post :submit, build_submit_payload(route_visit)

    route_visit.reload

    assert route_visit.fulfilled?, "route_visit should have been fulfilled"

    route_visit.fulfillments.each do |f|
      assert f.fulfilled?, "fulfillment should have been fulfilled"
      assert f.order.authorized?, "order should have been fulfilled"

      f.stock.stock_levels.each do |sl|
        assert_equal(99, sl.starting)
        assert_equal(99, sl.returns)

        assert sl.tracked?
      end

      f.order.order_items.each do |oi|
        assert_equal(99, oi.unit_price)
        assert_equal(99, oi.quantity)
      end

      f.credit_note.credit_note_items.each do |cni|
        assert_equal(99, cni.unit_price)
        assert_equal(99, cni.quantity)
      end

      assert_equal("Method Man", f.pod.name)
    end
  end

  test "missing items are left as is" do
    sign_in_as_driver

    order = create(:sales_order_with_items)
    fulfillment = create(:fulfillment, order:order)
    route_visit = create(:route_visit, fulfillments:[fulfillment])

    start_payload = build_submit_payload(route_visit)

    payload = build_submit_payload(route_visit)

    payload[:data][:fulfillments].first[:order].delete(:order_items)
    payload[:data][:fulfillments].first[:credit_note].delete(:credit_note_items)
    payload[:data][:fulfillments].first[:stock].delete(:stock_levels)

    post :submit, payload

    route_visit.reload

    end_payload = build_submit_payload(route_visit)

    assert_equal(start_payload, end_payload, "payload should not have changed")
  end

end
