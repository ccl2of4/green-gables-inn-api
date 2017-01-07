class JsonObject

  attr_accessor :json

  def to_json(options = {})
    return @json.to_json
  end

  def initialize(model, except=Set.new)
    @json = Hash.new
    add_data(model, except)
  end

  def relationship(key, jsonObject)
    if @json['data'].kind_of? Array
      raise Exception.new('Cannot add relationship to data array.')
    end
    jsonObject = JsonObject.new(jsonObject) if !jsonObject.kind_of? JsonObject
    add_relationship(key, jsonObject)
    return self
  end

  private def add_data(model, except)
    if model.respond_to? :each
      @json['data'] = model.map do |model_object|
        to_data(model_object, except)
      end
    else
      @json['data'] = to_data(model, except)
    end
  end

  private def add_relationship(key, jsonObject)
    @json['data']['relationships'] ||= {}
    @json['data']['relationships'][key] = jsonObject.json
  end

  private def to_data(model, except)
    data = Hash.new
    data['id'] = model.id
    data['type'] = model.class.table_name
    data['attributes'] = model.attributes.select do |k,v|
      k != 'id' && !except.include?(k)
    end
    data
  end

end
