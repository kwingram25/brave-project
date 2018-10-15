ARRAY_TYPES = {
  "characters" => "Person",
  "films" => "Film",
  "people" => "Person",
  "pilots" => "Person",
  "planets" => "Planet",
  "residents" => "Person",
  "species" => "Species",
  "starships" => "Starship",
  "vehicles" => "Vehicle"
}

def stripped_json(record)
  record.as_json.except('id', 'created_at', 'updated_at')
end

class Resource
  class << self
    attr_reader :path, :model_name

    def model
      @model_name.constantize
    end

    def connection
      url = "https://swapi.co/api/#{@path}/"
      @connection ||= Faraday.new({
        :headers => {
          'Content-Type': 'application/json'
        },
        :url => url
      }) do |faraday|
        faraday.response :json, :content_type => /\bjson$/
        faraday.adapter Faraday.default_adapter
      end
    end

    def schema
      @schema ||= connection.get('schema').body
    end

    # Access or download schema[properties]
    def attributes
      if !@attributes
        @attributes = {}
        schema['properties'].each do |key, prop|
          type = prop['type'] == 'array' ? ARRAY_TYPES[key] : prop['type']
          @attributes[key] = {
            :name => key,
            :type => type,
            :description => prop['description'],
            :required => schema['required'].include?(key)
          }
        end
      end
      @attributes
    end

    # Order of required resource properties
    def column_order
      @column_order ||= schema['required']
    end

    # Get from database or API if not found
    def get(id)
      result = get_from_db(id)
      if result.nil?
        response = get_from_api(id)
        if !response.nil?
          result = put_in_db(id, response)
        end
      end
      result.nil? ? nil : stripped_json(result)
    end

    def get_from_db(id)
      model.find_by(id: id)
    end

    def get_from_api(id)
      res = connection.get("#{id}/")
      res.status.to_i < 400 ? res.body : nil
    end

    def put_in_db(id, attrs)
      model.create(attrs.merge!({ id: id }))
    end

    # Migration column definitions
    def column_definitions(t)
      column_order.each do |column|
        attribute = attributes[column]
        if ARRAY_TYPES.values.include? attribute[:type]
          t.json :"#{column}"
        else
          t.send(attribute[:type], :"#{column}")
        end
      end
    end
  end
end