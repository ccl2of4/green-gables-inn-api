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
    attrs = get_client_attrs(params)
    @client = Client.new(attrs)
    @client.save
    @json = JsonObject.new @client
    render json:@json
  end

  private def get_client_attrs(params)
    params.require(:data)
          .require(:attributes)
          .permit([:full_name, :email_address, :phone_number])
          .tap {|attrs| attrs.require([:full_name, :email_address, :phone_number])}
  end

end
