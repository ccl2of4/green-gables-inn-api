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
    args = params.require(:data).require(:attributes).permit([:full_name, :email_address, :phone_number])
    args.tap do |attrs|
      attrs.require([:full_name, :email_address, :phone_number])
    end
    @client = Client.new(args)
    @client.save
    @json = JsonObject.new @client
    render json:@json
  end
end
