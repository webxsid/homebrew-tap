require "fileutils"

class Crona < Formula
  desc "Local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.9.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.9.0/crona-bundle-1.9.0-darwin-arm64.zip"
      sha256 "c323ef709bb179a907012202f8190af9649c5ad5509dd0b022dd286a385d1b4d"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.9.0/crona-bundle-1.9.0-darwin-amd64.zip"
      sha256 "ddf14f035e28faa78405a9ca26858267473aa3c7f8de8480cd0cc78620768b3a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.9.0/crona-bundle-1.9.0-linux-arm64.zip"
      sha256 "831ff46587ec27940c72d17c4bdf6f56849e8cce81008c55d5f2cfadeac0bb28"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.9.0/crona-bundle-1.9.0-linux-amd64.zip"
      sha256 "2a85a9055c216017663a1c996344c27b8e1fd84649e99c1233122745246daf5e"
    end
  end

  def crona_runtime_home
    if ENV["CRONA_HOME"] && !ENV["CRONA_HOME"].strip.empty?
      return ENV["CRONA_HOME"].strip
    end
    home = Dir.home
    if OS.mac?
      File.join(home, "Library", "Application Support", "Crona")
    else
      data_home = ENV["XDG_DATA_HOME"]
      if data_home && !data_home.strip.empty?
        File.join(data_home.strip, "crona")
      else
        File.join(home, ".local", "share", "crona")
      end
    end
  end

  def write_install_source(source, formula_name)
    runtime_home = crona_runtime_home
    FileUtils.mkdir_p(runtime_home)
    File.write(
      File.join(runtime_home, "install.json"),
      "{\n  \"installSource\": \"" + source + "\",\n  \"brewFormula\": \"" + formula_name + "\",\n  \"releaseChannel\": \"stable\"\n}\n",
    )
  end

  def install
    if OS.mac?
      if Hardware::CPU.arm?
        bin.install "crona"
        bin.install "crona-daemon"
        bin.install "crona-tui"
      else
        bin.install "crona"
        bin.install "crona-daemon"
        bin.install "crona-tui"
      end
    elsif OS.linux?
      if Hardware::CPU.arm?
        bin.install "crona"
        bin.install "crona-daemon"
        bin.install "crona-tui"
      else
        bin.install "crona"
        bin.install "crona-daemon"
        bin.install "crona-tui"
      end
    end
  end

  def post_install
    write_install_source("brew", "crona")
  end
  test do
    system "#{bin}/crona", "--version"
    system "#{bin}/crona-daemon", "--version"
  end
end
