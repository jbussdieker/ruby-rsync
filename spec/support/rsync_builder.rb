class RsyncBuilder
  attr_accessor :version

  def initialize(version)
    @version = version

    unless File.exists? "tmp"
      puts `mkdir -p tmp`
    end
  end

  def download
    unless File.exists? "tmp/rsync-#{version}.tar.gz"
      puts `cd tmp && wget https://download.samba.org/pub/rsync/src/rsync-#{version}.tar.gz`
    end
  end

  def extract
    unless File.exists? "tmp/rsync-#{version}"
      puts `cd tmp && tar zxvf rsync-#{version}.tar.gz`
    end
  end

  def configure
    unless File.exists? "tmp/rsync-#{version}/Makefile"
      puts `cd tmp/rsync-#{version} && ./configure`
    end
  end

  def compile
    unless File.exists? "tmp/rsync-#{version}/rsync"
      puts `cd tmp/rsync-#{version} && make`
    end
  end

  def build
    download
    extract
    configure
    compile
    "tmp/rsync-#{version}/rsync"
  end
end
