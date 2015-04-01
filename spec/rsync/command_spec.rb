require 'rsync/command'

describe Rsync::Command do
  it "should work" do
    expect(Rsync::Command.run("/path/to/src/", "/path/to/dest", "-a")).to be_kind_of(::Rsync::Result)
  end
end
