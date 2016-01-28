require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  def setup
    @client = clients(:wutang)
  end

  test "can view price_tier" do
    refute_empty @client.price_tier.name
  end
end
