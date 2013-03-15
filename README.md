# G5 Client App Creator

Provisions and deploys Apps automagically from Instruction Feed.

* Receives Webhook from Instruction Feed Publisher
* Consumes Instruction Feed
* Provisions Apps
* Deploys Apps


## Setup

1. Install all the required gems
```bash
$ bundle
```

1. Set up your database.
[rails-default-database](https://github.com/tpope/rails-default-database)
automatically uses sensible defaults for the primary ActiveRecord database.
```bash
$ rake db:setup
```

### Optional: Set Custom G5 Configurator Feed URL

1. Set environment variable `G5_CONFIGURATOR_FEED_URL`.
Defaults are set in `config/initializers/env.rb`.

### Optional: Set Custom G5 Client App Creator UID

1. Set environment variable `G5_CLIENT_APP_CREATOR_UID`.
Defaults are set in `config/initializers/env.rb`.

### Optional: Deploy Client Apps

1. [Create a new ssh key and add it to Github.](https://help.github.com/articles/generating-ssh-keys)
1. [Also add your ssh key to Heroku.](https://devcenter.heroku.com/articles/keys)
1. Set environment variable `HEROKU_API_KEY` to your Heroku API key.
1. Set environment variable `ID_RSA` to your private ssh key you generated.
1. Install [redis](http://redis.io/) and start it.
1. Start a worker `rake jobs:work`


## Authors

* Jessica Lynn Suttles / [@jlsuttles](https://github.com/jlsuttles)
* Bookis Smuin / [@bookis](https://github.com/bookis)
* Michael Mitchell / [@variousred](https://github.com/variousred)


## Contributing

1. Get it running
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Write your code and **specs**
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create new Pull Request

If you find bugs, have feature requests or questions, please
[file an issue](https://github.com/g5search/g5-client-app-creator/issues).


## Specs

Run once.
```bash
$ rspec spec
```

Keep then running.
```bash
$ guard
```

Coverage.
```bash
$ rspec spec
$ open coverage/index.html
```
