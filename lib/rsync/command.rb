module Rsync
  class Command
    def initialize(args)
      @args = args.join(" ")
    end

    def run
      run_command("rsync --itemize-changes #{@args}")
    end

    def run_command(cmd, &block)
      if block_given?
        IO.popen("#{cmd} 2>&1", &block)
      else
        `#{cmd} 2>&1`
      end
    end
  end
end
