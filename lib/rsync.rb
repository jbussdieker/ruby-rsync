require "rsync/version"
require "rsync/command"
require "rsync/result"

# The main interface to rsync
module Rsync
  # Creates and runs an rsync {Command} and return the {Result}
  # @param source {String}
  # @param destination {String}
  # @param args {Array}
  # @return {Result}
  # @yield {Result}
  def self.run(source, destination, args = [], &block)
    result = Command.run(source, destination, args)
    yield(result) if block_given?
    result
  end
end
