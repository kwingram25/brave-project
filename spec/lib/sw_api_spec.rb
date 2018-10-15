require "rails_helper"
require "./lib/sw_api"

include SWApi

resource_names = ['Person', 'Starship', 'Vehicle', 'Planet', 'Species', 'Film']
resource_classes = resource_names.map { |id| "#{id}Resource".constantize }
resource_ids = {
  Person: 1,
  Starship: 59,
  Vehicle: 14,
  Planet: 1,
  Species: 1,
  Film: 1
}

describe "sw_api wrapper" do
  resource_names.each do |name|
    c = "#{name}Resource".constantize

    it "instantiates #{name} resource class and model" do
      expect(name.constantize).to be_instance_of(Class)
      expect(c).to be_instance_of(Class)
    end

    it "loads #{name} record type schema" do
      expect(c.column_order).to be_instance_of(Array)
      expect(c.attributes).to be_instance_of(Hash)
    end

    it "retrieves #{name} records from api" do
      id = resource_ids[:"#{c.model_name}"]
      resource = c.get_from_api(id)

      expect(resource).to be_instance_of(Hash)
      c.column_order.each do |col|
        expect(resource[col]).to be_truthy
      end
    end

    it "stores and retrieves #{name} records in database" do
      id = resource_ids[:"#{c.model_name}"]

      remote = c.get_from_api(id)

      c.put_in_db(id, remote)

      local = c.get_from_db(id)

      expect(stripped_json(local)).to eq(stripped_json(remote))
    end
  end
end