# Benchmark::Perf

[![Gem Version](https://badge.fury.io/rb/benchmark-perf.svg)][gem]
[![Build Status](https://secure.travis-ci.org/piotrmurach/benchmark-perf.svg?branch=master)][travis]
[![Build status](https://ci.appveyor.com/api/projects/status/wv37qw3x5l9km5kl?svg=true)][appveyor]
[![Code Climate](https://codeclimate.com/github/piotrmurach/benchmark-perf/badges/gpa.svg)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/github/piotrmurach/benchmark-perf/badge.svg?branch=master)][coverage]
[![Inline docs](http://inch-ci.org/github/piotrmurach/benchmark-perf.svg?branch=master)][inchpages]

[gem]: http://badge.fury.io/rb/benchmark-perf
[travis]: http://travis-ci.org/piotrmurach/benchmark-perf
[appveyor]: https://ci.appveyor.com/project/piotrmurach/benchmark-perf
[codeclimate]: https://codeclimate.com/github/piotrmurach/benchmark-perf
[coverage]: https://coveralls.io/github/piotrmurach/benchmark-perf?branch=master
[inchpages]: http://inch-ci.org/github/piotrmurach/benchmark-perf

> Measure execution time and iterations per second.

The **Benchmark::Perf** is used by [rspec-benchmark](https://github.com/piotrmurach/rspec-benchmark)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'benchmark-perf'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install benchmark-perf

## Contents

* [1. Usage](#1-usage)
* [2. API](#2-api)
  * [2.1 Execution time](#21-execution-time)
  * [2.2 Iterations](#22-iterations)

## 1. Usage

To see how long it takes to execute code do:

```ruby
bench = Benchmark::Perf::ExecutionTime.new
mean, stddev = bench.run { ... }
```

## 2. API

### 2.1 Execution time

By default `30` samples are taken, and `1` sample for the warmup phase. If you need to change number of measurement samples do:

```ruby
Benchmark::Perf::ExecutionTime.run(times: 10) { ... }
```

And to change number of warmup cycles do:

```ruby
Benchmark::Perf::ExecutionTime.run(warmup: 2) { ... }
```

If you're interested in having debug output to see exact measurements for each iteration specify stream with `:io`:

```ruby
Benchmark::Perf::ExecutionTime.run(io: $stdout) { ... }
```

### 2.2 Iterations

In order to check how many iterations per second a given code takes do:

```ruby
mean, stddev, iter, elapsed_time = Benchmark::Perf::Iteration.run { ... }
```

By default `1` second is spent warming up Ruby VM, you change this passing `:warmup` :

```ruby
Benchmark::Perf::Itertion.run(warmup: 1.45) { ... } # 1.45 second
```

The measurements as sampled for `2` seconds, you can change this value to increase precision using `:time`:

```ruby
Benchmark::Perf::Iteration.run(time: 3.5) { ... } # 3.5 seconds
```

## Contributing

1. Fork it ( https://github.com/piotrmurach/benchmark-perf/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Copyright

Copyright (c) 2016-2018 Piotr Murach. See LICENSE for further details.
