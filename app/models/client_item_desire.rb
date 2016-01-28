class ClientItemDesire < ActiveRecord::Base
  belongs_to :client
  belongs_to :item
end
