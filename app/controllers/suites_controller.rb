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
    @suite = Suite.new(params.require(:data).require(:attributes).permit([:name, :price]))
    @suite.save
    @json = JsonObject.new @suite
    render json:@json
  end
  def update
    @suite = Suite.find(params[:id])
    @suite.update(params.require(:data).require(:attributes).permit([:name, :price]))
    @suite.save
    @json = JsonObject.new @suite
    render json:@json
  end
  def destroy
    @suite = Suite.find(params[:id])
    @suite.destroy
  end
end
