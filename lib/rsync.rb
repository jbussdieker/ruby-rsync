require "rsync/version"
require "rsync/command"
require "rsync/result"

module Rsync
  def self.command(args = [], &block)
    output = Command.new(args).run
    exitcode = $?
    result = Result.new(output, exitcode)
    yield(result) if block_given?
    result
  end
end
