class ClientsController < ApplicationController
  def index
    @clients = Client.all
    @json = JsonObject.new @clients
    render json:@json
  end
  def show
    @client = Client.find(params[:id])
    @json = JsonObject.new @client
    render json:@json
  end
  def create
    @client = Client.new(params.require(:data).require(:attributes).require([:full_name, :email_address, :phone_number]))
    @client.save
    @json = JsonObject.new @client
    render json:@json
  end
end
