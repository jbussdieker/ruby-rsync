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
      expect(Rsync).to respond_to(:host) 
      expect(Rsync.host).to eql('root@127.0.0.1')
    end

    describe "run" do
      it "prepend the host to the destination" do
        allow(Rsync::Command).to receive(:run)
        expect(Rsync::Command).to receive(:run).with('/foo1', 'root@127.0.0.1:/foo2', ["-a"])
        Rsync.run('/foo1', '/foo2', ["-a"])
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
    expect(@dest).to eql(@src)
  end

  it "should dry run" do
    @src.mkdir("blah")
    Rsync.run(@src.path + "/", @dest.path, ["-a", "-n"])
    expect(@dest).to_not eql(@src)
  end

  it "should list changes" do
    @src.mkdir("blah")
    result = Rsync.run(@src.path + "/", @dest.path, ["-a"])
    expect(result).to be_success
    expect(result.changes.length).to eql(1)
    expect(@dest).to eql(@src)
  end
end
