module Response
  def json_response(object, options = {})
    response_options = { json: object, status: :ok }
    response_options.merge!(options)

    headers['Location'] = response_options[:location] if response_options[:location]

    render response_options
  end
end
