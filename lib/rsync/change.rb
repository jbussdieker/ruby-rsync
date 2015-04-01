require 'rsync/change/v29'
require 'rsync/change/v30'

module Rsync
  module Change
    def self.new(raw, version)
      Rsync::Change.const_get("V#{version}").new(raw)
    end
  end
end
