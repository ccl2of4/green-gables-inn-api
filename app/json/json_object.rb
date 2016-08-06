class JsonObject

  attr_accessor :json

  def to_json(options = {})
    return @json.to_json
  end

  def initialize(model)
    @json = Hash.new
    add_data(model)
  end

  private def add_data(model)
    if model.respond_to? :each
      @json['data'] = model.map do |model_object|
        to_data(model_object)
      end
    else
      @json['data'] = to_data(model)
    end
  end

  private def to_data(model)
    data = Hash.new
    data['id'] = model.id
    data['type'] = model.class.table_name
    data['attributes'] = model.attributes.select do |k,v|
      k != 'id'
    end
    data
  end

end
