class CustomController < ApplicationJsonApiResourcesController
  def unique_check
    authorize :custom

    type, key, value = params.values_at(:type, :key, :value)
    clazz = type.camelize.constantize
    is_unique = clazz.where("trim(lower(#{key})) = ?", value.downcase.strip).empty?

    render json: {unique: is_unique}
  end
end
