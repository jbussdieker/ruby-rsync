require "rsync/version"
require "rsync/command"
require "rsync/result"

# The main interface to rsync
module Rsync
  # Creates and runs an rsync {Command} and return the {Result}
  # @return {Result}
  # @yield {Result}
  def self.command(args, &block)
    output = Command.new(args).run
    exitcode = $?
    result = Result.new(output, exitcode)
    yield(result) if block_given?
    result
  end
end
