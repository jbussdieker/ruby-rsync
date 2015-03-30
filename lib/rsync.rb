require "rsync/version"
require "rsync/command"
require "rsync/result"
require 'rsync/configure'

# The main interface to rsync
module Rsync
  extend Configure
  # Creates and runs an rsync {Command} and return the {Result}
  # @param source {String}
  # @param destination {String}
  # @param args {Array}
  # @return {Result}
  # @yield {Result}
  def self.run(source, destination, args = [], &block)
    destination = "#{self.host}:#{destination}" if self.host
    result = Command.run(source, destination, args)
    yield(result) if block_given?
    result
  end

  def self.protocol
    result = Command.run(nil, nil, "--version")
    result.instance_eval { @raw }.split("\n").first.match(/protocol version (\d+)/)
    $1
  end

  def self.version
    result = Command.run(nil, nil, "--version")
    result.instance_eval { @raw }.split("\n").first.match(/(\d+\.\d+\.\d+)/)
    $1
  end
end
