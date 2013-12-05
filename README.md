# Rsync

[![Build Status](https://travis-ci.org/jbussdieker/ruby-rsync.png?branch=master)](https://travis-ci.org/jbussdieker/ruby-rsync)
[![Code Climate](https://codeclimate.com/github/jbussdieker/ruby-rsync.png)](https://codeclimate.com/github/jbussdieker/ruby-rsync)
[![Gem Version](https://badge.fury.io/rb/rsync.png)](http://badge.fury.io/rb/rsync)

Ruby/Rsync is a Ruby library that can syncronize files between remote hosts by wrapping a call to the rsync binary.

## Usage

Minimal example
```ruby
    require "rsync"

    result = Rsync.run("/path/to/src", "/path/to/dest")
```

Complete example
```ruby
    require "rsync"

    Rsync.run("/path/to/src", "/path/to/dest") do |result|
      if result.success?
        result.changes.each do |change|
          puts "#{change.filename} (#{change.summary})"
        end
      else
        puts result.error
      end
    end
```
