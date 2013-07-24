require 'spec_helper'
require 'rsync'

describe Rsync do
  around(:each) do |example|
    TempDir.create do |src, dest|
      @src = src
      @dest = dest
      example.run
    end
  end

  it "should work" do
    @src.mkdir("blah")
    Rsync.run(@src.path + "/", @dest.path, ["-a"])
    @dest.should eql(@src)
  end

  it "should dry run" do
    @src.mkdir("blah")
    Rsync.run(@src.path + "/", @dest.path, ["-a", "-n"])
    @dest.should_not eql(@src)
  end

  it "should list changes" do
    @src.mkdir("blah")
    result = Rsync.run(@src.path + "/", @dest.path, ["-a"])
    result.should be_success
    result.changes.length.should eql(1)
    @dest.should eql(@src)
  end
end
