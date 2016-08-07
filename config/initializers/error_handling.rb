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
    log_error(request, wrapper)
    error_response(request, wrapper)
  end

  def error_response(request, wrapper)
    body = {
      errors: [{
        status: wrapper.status_code,
        title: Rack::Utils::HTTP_STATUS_CODES.fetch(
          wrapper.status_code,
          Rack::Utils::HTTP_STATUS_CODES[500]),
        detail: wrapper.exception.message
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

  def log_error(request, wrapper)
    logger = logger(request)
    return unless logger

    exception = wrapper.exception

    trace = wrapper.application_trace
    trace = trace[0...trace.length-1]
    trace = wrapper.framework_trace if trace.empty?

    ActiveSupport::Deprecation.silence do
      logger.fatal "  "
      logger.fatal "#{exception.class} (#{exception.message}):"
      log_array logger, exception.annoted_source_code if exception.respond_to?(:annoted_source_code)
      logger.fatal "  "
      log_array logger, trace
    end
  end

  def log_array(logger, array)
    array.map { |line| logger.fatal line }
  end

  def logger(request)
    request.logger || ActionView::Base.logger || stderr_logger
  end

  def stderr_logger
    @stderr_logger ||= ActiveSupport::Logger.new($stderr)
  end

end
