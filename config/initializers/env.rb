ENV["G5_CONFIGURATOR_FEED_URL"] ||= case Rails.env
  when "production" then "http://g5-configurator.herokuapp.com"
  when "development" then "http://g5-configurator.dev"
  when "test" then "http://g5-configurator.test"
end

ENV["G5_CLIENT_APP_CREATOR_UID"] ||= case Rails.env
  when "production" then "http://g5-configurator.herokuapp.com/apps/g5-client-app-creator"
  when "development" then "http://g5-configurator.dev/apps/g5-client-app-creator"
  when "test" then "http://g5-configurator.test/apps/g5-client-app-creator"
end

ENV["APP_NAMESPACE"] ||= "g5"
