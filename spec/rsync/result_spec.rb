require 'rsync/result'

describe Rsync::Result do
  it "should handle basic example" do
    result = Rsync::Result.new("", 0)
    result.changes.should eql([])
    result.error.should eql("Success")
    result.success?.should eql(true)
  end

  it "should handle basic example with changes" do
    result = Rsync::Result.new(">f......... filename\n", 0)
    result.changes.length.should eql(1)
    result.error.should eql("Success")
    result.success?.should eql(true)
  end

  it "should handle syntax error" do
    result = Rsync::Result.new("", 1)
    result.changes.should eql([])
    result.error.should eql("Syntax or usage error")
    result.success?.should eql(false)
  end
end
