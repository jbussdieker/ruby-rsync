require 'rsync/change'

describe Rsync::Change do
  it "should handle filename" do
    Rsync::Change.new("            filename").filename.should eql("filename")
  end

  it "should handle message type" do
    Rsync::Change.new("*deleting  ").summary.should eql("deleting")
  end

  it "should handle update types" do
    Rsync::Change.new("<          ").update_type.should eql(:sent)
    Rsync::Change.new(">          ").update_type.should eql(:recv)
    Rsync::Change.new("c          ").update_type.should eql(:change)
    Rsync::Change.new("h          ").update_type.should eql(:hard_link)
    Rsync::Change.new(".          ").update_type.should eql(:no_update)
    Rsync::Change.new("*          ").update_type.should eql(:message)
  end

  it "should handle file types" do
    Rsync::Change.new(" f         ").file_type.should eql(:file)
    Rsync::Change.new(" d         ").file_type.should eql(:directory)
    Rsync::Change.new(" L         ").file_type.should eql(:symlink)
    Rsync::Change.new(" D         ").file_type.should eql(:device)
    Rsync::Change.new(" S         ").file_type.should eql(:special)
  end

  it "should handle checksum info" do
    Rsync::Change.new("  c        ").checksum.should eql(:changed)
    Rsync::Change.new("  .        ").checksum.should eql(:no_change)
    Rsync::Change.new("           ").checksum.should eql(:identical)
    Rsync::Change.new("  +        ").checksum.should eql(:new)
    Rsync::Change.new("  ?        ").checksum.should eql(:unknown)
  end
end
