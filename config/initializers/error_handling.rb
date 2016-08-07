class ErrorHandling

  def initialize(app)
    @app = app
  end

  def call(env)
    request = ActionDispatch::Request.new env
    @app.call(env)
  rescue Exception => exception
    backtrace_cleaner = request.get_header('action_dispatch.backtrace_cleaner')
    wrapper = ActionDispatch::ExceptionWrapper.new(backtrace_cleaner, exception)
    return_error_response(request, wrapper)
  end

  def return_error_response(request, wrapper)
    body = {
      errors: [{
        status: wrapper.status_code,
        title: Rack::Utils::HTTP_STATUS_CODES.fetch(
          wrapper.status_code,
          Rack::Utils::HTTP_STATUS_CODES[500]),
        detail: wrapper.exception.inspect
      }],

      #exception: wrapper.exception.inspect,
      #traces: wrapper.traces
    }

    content_type = request.formats.first
    to_format = "to_#{content_type.to_sym}"

    if content_type && body.respond_to?(to_format)
      formatted_body = body.public_send(to_format)
      format = content_type
    else
      formatted_body = body.to_json
      format = Mime[:json]
    end

    render(wrapper.status_code, formatted_body, format)
  end

  def render(status, body, format)
    [status, {'Content-Type' => "#{format}; charset=#{ActionDispatch::Response.default_charset}", 'Content-Length' => body.bytesize.to_s}, [body]]
  end

end
