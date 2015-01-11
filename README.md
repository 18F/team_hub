## team_hub Gem

[![Gem Version](https://badge.fury.io/rb/team_hub.svg)](https://badge.fury.io/rb/team_hub)
[![Build Status](https://travis-ci.org/18F/team_hub.svg?branch=master)](https://travis-ci.org/18F/team_hub)
[![Code Climate](https://codeclimate.com/github/18F/team_hub/badges/gpa.svg)](https://codeclimate.com/github/18F/team_hub)
[![Test Coverage](https://codeclimate.com/github/18F/team_hub/badges/coverage.svg)](https://codeclimate.com/github/18F/team_hub)

Contains reusable components extracted from the [18F Hub
implementation](https://github.com/18F/hub) for creating a team Hub using
[Jekyll](http://jekyllrb.com/). See the [18F Public
Hub](https://18f.gsa.gov/hub/) for a running example.

Downloads and API docs are available on the [team_hub RubyGems
page](https://rubygems.org/gems/team_hub). API documentation is written
using [YARD markup](http://yardoc.org/).

Contributed by the 18F team, part of the United States General Services
Administration: https://18f.gsa.gov/

### Motivation

The [18F Hub repository](https://github.com/18F/hub) aims to provide a
lightweight, easily-adaptable template for websites like the [18F Public
Hub](https://18f.gsa.gov/hub/), [to empower Instigators across the US federal
government and beyond to spread modern software development
practices](https://18f.gsa.gov/2014/12/23/hub/).  Consequently, 18F will be
extracting more and more generic, reusable components into this gem, leaving
the plugins in the 18F Hub repository very lean and declarative, so that
others may more easily understand how to adapt the Hub template to their own
team's needs.

### Installation

Add this line to your application's Gemfile:

```ruby
gem 'team_hub'
```

And then execute:
```
$ bundle
```

Or install it yourself as:
```
$ gem install team_hub
```

### Usage

More documentation will be forthcoming as this gem is built up with features
extracted from the 18F Hub. For now, see the [18F Hub Plugins
directory](https://github.com/18F/hub/tree/master/_plugins) to see how parts
of `team_hub` are currently used, and to see hints of functionality that will
be added to `team_hub` in the near future.

### Contributing

1. Fork it ( https://github.com/18F/team_hub/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

Feel free to ping [@mbland](https://github.com/mbland) with any questions you
may have, especially if the current documentation should've addressed your
needs, but didn't.

### Public domain

This project is in the worldwide [public domain](LICENSE.md). As stated in
[CONTRIBUTING](CONTRIBUTING.md):

> This project is in the public domain within the United States, and copyright
> and related rights in the work worldwide are waived through the
> [CC0 1.0 Universal public domain dedication](https://creativecommons.org/publicdomain/zero/1.0/).
>
> All contributions to this project will be released under the CC0 dedication.
> By submitting a pull request, you are agreeing to comply with this waiver of
> copyright interest.
