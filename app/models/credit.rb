class Credit < ActiveRecord::Base
  belongs_to :client
  has_many :credit_items, -> { joins(:item).order('position') }, :dependent => :destroy, autosave: true
end
