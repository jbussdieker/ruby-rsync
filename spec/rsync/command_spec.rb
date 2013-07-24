require 'rsync/command'

describe Rsync::Command do
  it "should work" do
    Rsync::Command.run("/path/to/src/", "/path/to/dest", "-a").should be_kind_of(Rsync::Result)
  end
end
