require 'rsync/result'

describe Rsync::Result do
  it "should handle basic example" do
    result = Rsync::Result.new("", 0)
    expect(result.changes).to eql([])
    expect(result.error).to eql("Success")
    expect(result.success?).to eql(true)
    expect(result.exitcode).to eql(0)
  end

  it "should handle basic example with changes" do
    result = Rsync::Result.new(">f......... filename\n", 0)
    expect(result.changes.length).to eql(1)
    expect(result.error).to eql("Success")
    expect(result.success?).to eql(true)
    expect(result.exitcode).to eql(0)
  end

  it "should handle syntax error" do
    result = Rsync::Result.new("", 1)
    expect(result.changes).to eql([])
    expect(result.error).to eql("Syntax or usage error")
    expect(result.success?).to eql(false)
    expect(result.exitcode).to eql(1)
  end
end
