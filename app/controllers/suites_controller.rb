class SuitesController < ApplicationController
  def index
    @suites = Suite.all
    @json = JsonObject.new @suites
    render json:@json
  end
  def show
    @suite = Suite.find(params[:id])
    render json:@suite
  end
  def create
    @suite = Suite.new(params.require(:suite).permit(:name, :description, :price))
    @suite.save
    render json:@suite
  end
  def update
    @suite = Suite.find(params[:id])
    @suite.update(params.require(:suite).permit(:name, :description, :price))
    @suite.save
    render json:@suite
  end
  def destroy
    @suite = Suite.find(params[:id])
    @suite.destroy
  end
end
