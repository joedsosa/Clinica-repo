# Allow all requests temporarily
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins do |source, _env|
      ENV['CORS_ORIGINS'].split(',').any? do |origin|
        URI.parse(origin.strip).host == URI.parse(source).host
      end
    end
    resource '*',
             headers: :any,
             expose: %w[access-token expiry token-type uid client],
             methods: %i[get post delete put patch options head],
             max_age: 0
  end
end
