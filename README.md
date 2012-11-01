# G5 Hub

A Rails application that consumes a feed consisting of hEntries as defined by [Microformats 2](http://microformats.org/wiki/microformats-2#h-entry) from [g5-configurator.herokuapp.com](http://g5-configurator.herokuapp.com). Each Entry is a set of instructions that the app creator will act on.


## Setup

1. Install all the required gems
Add GEM_FURY_SECRET to ENV
```bash
export GEM_FURY_SECRET="SUPER_SECRET_KEY"
```

```bash
bundle
```

1. Set up your database
```bash
cp config/database.example.yml config/database.yml
vi config/database.yml # edit username
rake db:create db:schema:load db:seed
```

## Authors

  * Jessica Lynn Suttles / [@jlsuttles](https://github.com/jlsuttles)
  * Bookis Smuin / [@bookis](https://github.com/bookis)


## Contributing

1. Fork it
1. Get it running
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Write your code and **specs**
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create new Pull Request

If you find bugs, have feature requests or questions, please
[file an issue](https://github.com/G5/g5_client_hub_creator/issues).


## License

???
