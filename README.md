# JsonApiFilter

Filter for rails controller based on JsonAPI spec: `/books?filter[library_id]=1,2&filter[author_id][eq]=12&filter[created_at][gt]=2021-02-02`

[![Maintainability](https://api.codeclimate.com/v1/badges/92a4a44d4af2bfa3b27d/maintainability)](https://codeclimate.com/github/evalmee/json_api_filter/maintainability)
[![Gem Version](https://badge.fury.io/rb/json_api_filter.svg)](https://badge.fury.io/rb/json_api_filter)
[![Build Status](https://travis-ci.com/evalmee/json_api_filter.svg?branch=master)](https://travis-ci.com/evalmee/json_api_filter)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'json_api_filter'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install json_api_filter
```

## Usage

### Quick start

To filter this request `/books?filter[library_id]=1,2&filter[author_id]=12&search=Lord of the ring`

```ruby
class Book < ApplicationController

  include JsonApiFilter
  permitted_filters  %i[library_id author_id]
  permitted_searches :user_search
  
  def index
    @books = json_api_filter(Book, params)
  end
    
end

```

- `permitted_filters` let you define allowed attributes to filter on (mandatory)
- `permitted_searches` let you define the allowed search method defined in you model what will be called if you pass `search` params in your request (can be a pg_search scope)
- `json_api_filter(scope, params)` return an active record relation (`Book::` in this example)
  
## Migration from 0.1
0.2.x version is not compatible with 0.1
In your controller, you will have to replace all occurrences of `attr_filter` as bellow :

### Before
```ruby
def index 
  @books = Book.all.where(attr_filter(params))
end
```

### After
```ruby
def index
  @books = json_api_filter(Book, params)
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Blaked84/json_api_filter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the JsonApiFilter project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Blaked84/json_api_filter/blob/master/CODE_OF_CONDUCT.md).
