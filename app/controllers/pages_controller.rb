class PagesController < ApplicationController
  def index
    @id = params[:id]
    @type = params[:type]

    if (!@id || !@type)
      @id = 1
      @type = 'people'
    end

    @resource = GetResourceService.new({
      id: @id,
      type: @type
    }).call

    respond_to do |format|
      format.html
      format.js   # AJAX loading of new id/type
    end
  end
end
