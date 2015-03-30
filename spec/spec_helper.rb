require 'coveralls'
Coveralls.wear!

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
root = File.expand_path("./..", __FILE__)

Dir[File.join(root, "support/**/*.rb")].each { |f| require f }

RSpec.configure do |spec|
  spec.before(:suite) do
    if ENV["RSYNC_VERSION"]
      version = ENV["RSYNC_VERSION"] || "2.6.9"

      builder = RsyncBuilder.new(version)
      cmd = builder.build

      puts `#{cmd} --version`
      Rsync::Command.command = cmd
    end
  end
end
