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
      puts `rm -rf tmp && mkdir tmp`
      puts `cd tmp && wget https://download.samba.org/pub/rsync/src/rsync-#{version}.tar.gz`
      puts `cd tmp && tar zxvf rsync-#{version}.tar.gz`
      puts `cd tmp/rsync-#{version} && ./configure`
      puts `cd tmp/rsync-#{version} && make`
      puts `tmp/rsync-#{version}/rsync --version`
      Rsync::Command.command = "tmp/rsync-#{version}/rsync"
    end
  end
end
