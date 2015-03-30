require 'tmpdir'

class TempDir
  attr_accessor :path

  def initialize(root, subpath)
    @path = File.join(root, subpath)
    Dir.mkdir(@path)
  end

  def tree
    `which tree`
    if $?.to_i == 0
      `cd #{@path}; tree -pugAD`
    else
      #`cd #{@path}; find . -printf "%A@ %p\n"`
      `cd #{@path}; find . -printf "%p\n"`
    end
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
