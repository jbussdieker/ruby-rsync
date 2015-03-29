require 'tmpdir'
require 'coveralls'
Coveralls.wear!

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

class TempDir
  attr_accessor :path

  def initialize(root, subpath)
    @path = File.join(root, subpath)
    Dir.mkdir(@path)
  end

  def tree
    #`cd #{@path}; tree -pugAD`
    #`cd #{@path}; find . -printf "%A@ %p\n"`
    `cd #{@path}; find . -printf "%p\n"`
  end

  def mkdir(path)
    Dir.mkdir(File.join(@path, path))
  end

  def eql? other
    tree == other.tree
  end

  def to_s
    tree
  end

  def self.create(&block)
    Dir.mktmpdir do |dir|
      yield new(dir, "src"), new(dir, "dest")
    end
  end
end
