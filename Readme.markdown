# Findi

Find your iPhone through Apple's Find my iPhone API's.

A Ruby port of [findi](https://github.com/pearkes/findi) by [pearkes](https://github.com/pearkes).

## Installation

Add this line to your application's Gemfile:

    gem 'findi'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install findi

## Usage

``` ruby
> client = Findi::Client.new('steve@mac.com', 'password')
> client.devices
```

## Contributing

See the [contributing guide](Contributing.markdown).
