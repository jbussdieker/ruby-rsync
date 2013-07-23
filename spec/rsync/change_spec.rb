require 'rsync/change'

describe Rsync::Change do
  it "should handle example" do
    Rsync::Change.new(".f          blah2.txt")
  end
end

describe Rsync::Change::Detail do
  it "should handle filename" do
    Rsync::Change::Detail.new("            filename").filename.should eql("filename")
  end

  it "should handle message type" do
    Rsync::Change::Detail.new("*deleting  ").message.should eql("deleting")
  end

  it "should handle update types" do
    Rsync::Change::Detail.new("<          ").update_type.should eql(:sent)
    Rsync::Change::Detail.new(">          ").update_type.should eql(:recv)
    Rsync::Change::Detail.new("c          ").update_type.should eql(:change)
    Rsync::Change::Detail.new("h          ").update_type.should eql(:hard_link)
    Rsync::Change::Detail.new(".          ").update_type.should eql(:no_update)
    Rsync::Change::Detail.new("*          ").update_type.should eql(:message)
  end

  it "should handle file types" do
    Rsync::Change::Detail.new(" f         ").file_type.should eql(:file)
    Rsync::Change::Detail.new(" d         ").file_type.should eql(:directory)
    Rsync::Change::Detail.new(" L         ").file_type.should eql(:symlink)
    Rsync::Change::Detail.new(" D         ").file_type.should eql(:device)
    Rsync::Change::Detail.new(" S         ").file_type.should eql(:special)
  end

  it "should handle checksum info" do
    Rsync::Change::Detail.new("  c        ").checksum.should eql(:changed)
    Rsync::Change::Detail.new("  .        ").checksum.should eql(:no_change)
    Rsync::Change::Detail.new("           ").checksum.should eql(:identical)
    Rsync::Change::Detail.new("  +        ").checksum.should eql(:new)
    Rsync::Change::Detail.new("  ?        ").checksum.should eql(:unknown)
  end
end
