if Rails.env.test? || Rails.env.development?
  require "awesome_print"
  AwesomePrint.pry!
end
