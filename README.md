# G5 Client App Creator

[![Build Status](https://travis-ci.org/G5/g5-client-app-creator.png?branch=master)](https://travis-ci.org/G5/g5-client-app-creator)
[![Code Climate](https://codeclimate.com/repos/531ea1bae30ba00f7800187c/badges/543568b0ebef2bbdeff7/gpa.png)](https://codeclimate.com/repos/531ea1bae30ba00f7800187c/feed)

1. Receives webhook from g5-configurator
1. Reads g5-configurator's instruction feed
1. Provisions and deploys apps from instruction feed


## Setup

1. Install all the required gems
```bash
$ bundle
```
1. Copy example database file
```bash
$ cp config/database.example.yml config/database.yml
```

1. Set up your database
```bash
$ rake db:setup
```

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
[file an issue](https://github.com/G5/g5-client-app-creator/issues).


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

## License


Copyright (c) 2013 G5

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
