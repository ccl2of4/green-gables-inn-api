class SuitesController < ApplicationController

  def index
    @suites = Suite.all
    @json = JsonObject.new @suites
    render json:@json
  end

  def show
    @suite = Suite.find(params[:id])
    @json = JsonObject.new @suite
    render json:@json
  end

  def create
    attrs = get_suite_attrs(params)
    @suite = Suite.new(attrs)
    @suite.save
    @json = JsonObject.new @suite
    render json:@json
  end

  def update
    @suite = Suite.find(params[:id])
    attrs = get_suite_attrs(params)
    @suite.update(attrs)
    @suite.save
    @json = JsonObject.new @suite
    render json:@json
  end

  def destroy
    @suite = Suite.find(params[:id])
    @suite.destroy
  end

  private def get_suite_attrs(params)
    params.require(:data)
          .require(:attributes)
          .permit([:name, :price])
  end

end
