require './lib/sw_api'

include SWApi

class CreateResourceTables < ActiveRecord::Migration[5.2]
  # Generate models for each resource type - Person, Planet, ...
  def change
    SWApi::RESOURCE_TYPES.each do |_, model_name|
      resource_class = "#{model_name}Resource".constantize

      create_table :"#{resource_class.path}" do |t|
        resource_class.column_definitions(t)
        t.timestamps
      end
    end
  end
end
