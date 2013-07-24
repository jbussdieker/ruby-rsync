module Rsync
  # An rsync command to be run
  class Command
    def initialize(args)
      @args = args.join(" ")
    end

    # Runs the rsync job and returns the results
    #
    # @return {Result}
    def run
      run_command("rsync --itemize-changes #{@args}")
    end

private

    def run_command(cmd, &block)
      if block_given?
        IO.popen("#{cmd} 2>&1", &block)
      else
        `#{cmd} 2>&1`
      end
    end
  end
end
