require 'rsync/change'

describe Rsync::Change do
  context "protocol version 30" do
    it "should handle filename" do
      expect(Rsync::Change.new("            filename", 30).filename).to eql("filename")
    end

    it "should handle message type" do
      expect(Rsync::Change.new("*deleting  ", 30).summary).to eql("deleting")
    end

    it "should handle update types" do
      expect(Rsync::Change.new("<          ", 30).update_type).to eql(:sent)
      expect(Rsync::Change.new(">          ", 30).update_type).to eql(:recv)
      expect(Rsync::Change.new("c          ", 30).update_type).to eql(:change)
      expect(Rsync::Change.new("h          ", 30).update_type).to eql(:hard_link)
      expect(Rsync::Change.new(".          ", 30).update_type).to eql(:no_update)
      expect(Rsync::Change.new("*          ", 30).update_type).to eql(:message)
    end

    it "should handle file types" do
      expect(Rsync::Change.new(" f         ", 30).file_type).to eql(:file)
      expect(Rsync::Change.new(" d         ", 30).file_type).to eql(:directory)
      expect(Rsync::Change.new(" L         ", 30).file_type).to eql(:symlink)
      expect(Rsync::Change.new(" D         ", 30).file_type).to eql(:device)
      expect(Rsync::Change.new(" S         ", 30).file_type).to eql(:special)
    end

    it "should handle checksum info" do
      expect(Rsync::Change.new("  c        ", 30).checksum).to eql(:changed)
      expect(Rsync::Change.new("  .        ", 30).checksum).to eql(:no_change)
      expect(Rsync::Change.new("           ", 30).checksum).to eql(:identical)
      expect(Rsync::Change.new("  +        ", 30).checksum).to eql(:new)
      expect(Rsync::Change.new("  ?        ", 30).checksum).to eql(:unknown)
    end
  end
end
