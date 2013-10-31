module Rsync
  module Configure
    VALID_OPTION_KEYS = [
      :host
    ].freeze

    attr_accessor *VALID_OPTION_KEYS
    
    def configure
      yield self
    end    
  end
end
