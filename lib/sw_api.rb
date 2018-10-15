require './lib/sw_api_resource'

module SWApi
  RESOURCE_TYPES = [
    'films',     # Film
    'people',    # Person
    'planets',   # Planet
    'species',   # Species
    'starships', # Starship
    'vehicles'   # Vehicle
  ].map{ |s| [s, s.singularize.upcase_first] }.to_h

  def resource_class(type)
    if RESOURCE_TYPES.keys.include? type
      "#{RESOURCE_TYPES[type]}Resource".constantize
    end
  end

  # Generate Resource subclasses for each type
  RESOURCE_TYPES.each do |resource_name, model_name|
    eval("
      class #{model_name}Resource < Resource
        @path = '#{resource_name}'
        @model_name = '#{model_name}'
      end",
    TOPLEVEL_BINDING)
  end

  # Generate ApplicationRecord models for each type
  RESOURCE_TYPES.each do |_, model_name|
    resource_class = "#{model_name}Resource".constantize
    eval(
      "class #{model_name} < ApplicationRecord
        #{resource_class.attributes.values.map { |a|
          "validates :#{a[:name]}#{a[:required] ? ", presence: true" : ""}"
        } * "\n"}
      end",
    TOPLEVEL_BINDING)
  end
end