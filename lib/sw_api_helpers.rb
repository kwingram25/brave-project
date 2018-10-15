module SWApi
  def stripped_json(record)
    record.as_json.except('id', 'created_at', 'updated_at')
  end
end