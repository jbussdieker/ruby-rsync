require 'rsync/change'

module Rsync
  # The result of a sync.
  class Result
    # @!visibility private
    def initialize(raw, exitcode)
      @raw = raw
      @exitcode = exitcode
    end

    # Whether the rsync job was run without errors.
    # @return {Boolean}
    def success?
      @exitcode.to_i == 0
    end

    # The error message based on exit code.
    # @return {String}
    def error
      case @exitcode.to_i
        when 0 
          "Success"
        when 1
          "Syntax or usage error"
        when 2
          "Protocol incompatibility"
        when 3
          "Errors selecting input/output files, dirs"
        when 4
          "Requested action not supported: an attempt was made to manipulate 64-bit files on a platform that can not support them; or an option was specified that is supported by the client and not by the server."
        when 5
          "Error starting client-server protocol"
        when 6
          "Daemon unable to append to log-file"
        when 10
          "Error in socket I/O"
        when 11
          "Error in file I/O"
        when 12
          "Error in rsync protocol data stream"
        when 13
          "Errors with program diagnostics"
        when 14
          "Error in IPC code"
        when 20
          "Received SIGUSR1 or SIGINT"
        when 21
          "Some error returned by waitpid()"
        when 22
          "Error allocating core memory buffers"
        when 23
          "Partial transfer due to error"
        when 24
          "Partial transfer due to vanished source files"
        when 25
          "The --max-delete limit stopped deletions"
        when 30
          "Timeout in data send/receive"
        when 35
          "Timeout waiting for daemon connection"
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
        if line =~ /^([<>ch\.\*].{10}) (.*)$/
          detail = Change.new(line)
          list << detail if detail.changed?
        end
      end
      list
    end
  end
end
