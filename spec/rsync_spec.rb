require 'spec_helper'
require 'rsync'

describe Rsync do

  context 'with configurations' do
    before do
      Rsync.configure do |config|
        config.host = 'root@127.0.0.1'
      end
    end

    it "should respond to host" do
      Rsync.should respond_to(:host) 
      Rsync.host.should == 'root@127.0.0.1'
    end

    describe "run" do
      it "prepend the host to the destination" do
        Rsync::Command.stub(:run)
        Rsync.run('/foo1', '/foo2', ["-a"])
        Rsync::Command.should have_received(:run).with('/foo1', 'root@127.0.0.1:/foo2', ["-a"])
      end
    end
  end

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
