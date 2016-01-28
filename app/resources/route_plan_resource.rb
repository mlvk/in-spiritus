class RoutePlanResource < JSONAPI::Resource
  attributes :name, :template, :date

  has_one :user
  has_many :route_visits

  filter :date
  filter :template
  filter :user
  filter :id

  paginator :offset

  # def self.records(options = {})
  #   context = options[:context]
  #   current_user = context[:current_user]
  #   RoutePlan.where(user:current_user)
  # end

end
