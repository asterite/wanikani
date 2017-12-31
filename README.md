# wanikani

Provides access to [wanikani](https://www.wanikani.com)'s [API](https://www.wanikani.com/api) in Crystal.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  wanikani:
    github: asterite/wanikani
```

## Docs

[API docs](https://asterite.github.io/wanikani/)

## Usage

```crystal
require "wanikani"

api = Wanikani::API.new "your_api_key"

# Get user information
api.user_information

# Get radicals up to your level
api.radicals

# Get radicals up to a given level
api.radicals()

# Get radicals from multiple levels
api.radicals("1,3")

# And other similar methods...
```

## Contributing

1. Fork it ( https://github.com/asterite/wanikani/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [asterite](https://github.com/asterite) Ary Borenszweig - creator, maintainer
