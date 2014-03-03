# The URL to the instruction feed
ENV["G5_CONFIGURATOR_FEED_URL"] ||= case Rails.env
  when "production" then "http://g5-configurator.herokuapp.com"
  when "development" then "http://g5-configurator.dev"
  when "test" then "http://g5-configurator.test"
end

# The URL to this application
ENV["G5_CLIENT_APP_CREATOR_UID"] ||= case Rails.env
  when "production" then "http://g5-configurator.herokuapp.com/apps/g5-client-app-creator"
  when "development" then "http://g5-configurator.dev/apps/g5-client-app-creator"
  when "test" then "http://g5-configurator.test/apps/g5-client-app-creator"
end

# Used to determine the top-level namespace for your infrastructure,
# e.g. the g5 in g5-cms-ab123-my-apartments
#
# If you plan on building a parallel infrastructure with a separate prefix for
# its deployed applications, you should set this.
ENV["APP_NAMESPACE"] ||= "g5"
