module Helpers
  module ResourceHelpers

    # Builds jr style hash for functional tests.
    # Models should be passed in as symbols
    # This will attempt to build the jr resource and factory girl build a model
    # Then deletes the links and relationships in the hash so it can be posted
    def build_jr_hash(model)
      clazz = eval("#{model.to_s.capitalize}Resource")

      hash = JSONAPI::ResourceSerializer.new(clazz).serialize_to_hash(clazz.new(build(model), nil))
      hash[:data].delete("relationships")
      hash[:data].delete("links")
      return hash
    end
  end
end
