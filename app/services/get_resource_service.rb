include SWApi

class GetResourceService
  def initialize(params)
    @type = params[:type]
    @id = params[:id]
  end

  def call
    puts SWApi::RESOURCE_TYPES.keys
    puts @type
    puts SWApi::RESOURCE_TYPES.keys.include?(@type)
    puts @id.is_a?(Integer)
    if SWApi::RESOURCE_TYPES.keys.include?(@type) && @id.to_i.is_a?(Integer)
      puts 'trueeeeee'
      SWApi::resource_class(@type).get(@id)
    end
  end
end