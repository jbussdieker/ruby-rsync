require 'rsync/change'

module Rsync
  # The result of a sync.
  class Result
    # Exit code returned by rsync
    attr_accessor :exitcode

    # Error messages by exit code
    ERROR_CODES = {
      "0" => "Success",
      "1" => "Syntax or usage error",
      "2" => "Protocol incompatibility",
      "3" => "Errors selecting input/output files, dirs",
      "4" => "Requested action not supported: an attempt was made to manipulate 64-bit files on a platform that can not support them; or an option was specified that is supported by the client and not by the server.",
      "5" => "Error starting client-server protocol",
      "6" => "Daemon unable to append to log-file",
      "10" => "Error in socket I/O",
      "11" => "Error in file I/O",
      "12" => "Error in rsync protocol data stream",
      "13" => "Errors with program diagnostics",
      "14" => "Error in IPC code",
      "20" => "Received SIGUSR1 or SIGINT",
      "21" => "Some error returned by waitpid()",
      "22" => "Error allocating core memory buffers",
      "23" => "Partial transfer due to error",
      "24" => "Partial transfer due to vanished source files",
      "25" => "The --max-delete limit stopped deletions",
      "30" => "Timeout in data send/receive",
      "35" => "Timeout waiting for daemon connection"
    }

    # @!visibility private
    def initialize(raw, exitcode)
      @raw = raw
      @exitcode = exitcode
    end

    # Whether the rsync job was run without errors.
    # @return {Boolean}
    def success?
      @exitcode == 0
    end

    # The error message based on exit code.
    # @return {String}
    def error
      error_key = @exitcode.to_s
      if ERROR_CODES.has_key? error_key
        ERROR_CODES[error_key]
      else
        "Unknown Error"
      end
    end

    # List of changes made during this run.
    #
    # @return {Array<Change>}
    def changes
      change_list
    end

private

    def change_list
      list = []
      @raw.split("\n").each do |line|
        #if line =~ /^([<>ch.*][fdLDS][ .+\?cstTpoguax]{9}) (.*)$/
        if line =~ /^([<>ch+\.\*].{10}) (.*)$/
          detail = Change.new(line)
          list << detail if detail.changed?
        end
      end
      list
    end
  end
end
