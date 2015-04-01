require 'rsync/result'

describe Rsync::Result do
  it "should handle basic example" do
    result = Rsync::Result.new("", 0)
    expect(result.changes).to eql([])
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

  {
    "protocol version 30" => ">f......... filename\n",
    "protocol version 29" => ">f....... filename\n",
  }.each do |title, sample|
    context title do
      let(:result) { Rsync::Result.new(sample, 0) }

      it "should contain one change" do
        expect(result.changes.length).to eql(1)
      end

      it "should set .error to 'Success'" do
        expect(result.error).to eql("Success")
      end

      it "should return true for .successful" do
        expect(result.success?).to eql(true)
      end

      it "should return 0 for .exitcode" do
        expect(result.exitcode).to eql(0)
      end
    end
  end
end
