GithubHerokuDeployer.configure do |config|
  config.github_repo     = nil
  config.heroku_api_key  = ENV["HEROKU_API_KEY"]
  config.heroku_app_name = nil
  config.heroku_repo     = nil
  config.heroku_username = ENV["HEROKU_USERNAME"]
  config.id_rsa          = ENV["ID_RSA"]
  config.logger          = Rails.logger
  config.repo_dir        = File.join(Rails.root, "tmp", "repos")
end
