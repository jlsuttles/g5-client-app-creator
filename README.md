# G5 Client App Creator

1. Receives webhook from g5-configurator
1. Reads g5-configurator's instruction feed
1. Provisions and deploys apps from instruction feed


## Setup

1. Install all the required gems
```bash
$ bundle
```

1. Set up your database
```bash
$ rake db:setup
```
[rails-default-database](https://github.com/tpope/rails-default-database)
automatically uses sensible defaults for the primary ActiveRecord database

1. Customize setup by overriding default environment variables, which are set
   in [config/initializers/env.rb](config/initializers/env.rb)

1. Manually read the g5-configurator instruction feed
```bash
$ rake update_feed
```


## Deploy Apps to Heroku

1. [Generate a new ssh key and add it to Github](https://help.github.com/articles/generating-ssh-keys)
1. [Add the same ssh key to Heroku](https://devcenter.heroku.com/articles/keys)
1. Set environment variables
    - `HEROKU_API_KEY`
    - `HEROKU_USERNAME`
    - `ID_RSA` the ssh key you just generated
1. Start [redis](http://redis.io/)
1. Start a resque worker with `rake jobs:work`


## Authors

* Jessica Lynn Suttles / [@jlsuttles](https://github.com/jlsuttles)
* Bookis Smuin / [@bookis](https://github.com/bookis)
* Michael Mitchell / [@variousred](https://github.com/variousred)
* Chris Stringer / [@jcstringer](https://github.com/jcstringer)
* Don Petersen / [@dpetersen](https://github.com/dpetersen)
* Jessica Dillon / [@jessicard](https://github.com/jessicard)


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
