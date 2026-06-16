require "fileutils"

class CronaBeta < Formula
  desc "local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.6.0-beta.3"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.6.0-beta.3/crona-bundle-1.6.0-beta.3-darwin-arm64.zip"
      sha256 "6b40d5efd6534459a07455ba4abeec7b0d7dd92a0e27e3d1c2fbbd2801a9ef3a"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.6.0-beta.3/crona-bundle-1.6.0-beta.3-darwin-amd64.zip"
      sha256 "3e863357d6bef33533313000a4931c7bca5c6be5d3e495f33ead4ae829b5d81f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.6.0-beta.3/crona-bundle-1.6.0-beta.3-linux-arm64.zip"
      sha256 "c17177bf9a6d5a20cd236a42890f45f9676945708ede6a1664de27c5589fa4c3"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.6.0-beta.3/crona-bundle-1.6.0-beta.3-linux-amd64.zip"
      sha256 "f33616aa50b66049f2f7ca2c0f203a418a612c5cc58109beeb21b15afc1c6bec"
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
      "{\n  \"installSource\": \"" + source + "\",\n  \"brewFormula\": \"" + formula_name + "\"\n}\n",
    )
  end

  def install
    if OS.mac?
      if Hardware::CPU.arm?
        bin.install "crona"
        bin.install "crona-kernel"
        bin.install "crona-tui"
      else
        bin.install "crona"
        bin.install "crona-kernel"
        bin.install "crona-tui"
      end
    elsif OS.linux?
      if Hardware::CPU.arm?
        bin.install "crona"
        bin.install "crona-kernel"
        bin.install "crona-tui"
      else
        bin.install "crona"
        bin.install "crona-kernel"
        bin.install "crona-tui"
      end
    end
  end

  def post_install
    write_install_source("brew", "crona-beta")
  end
  test do
    system "#{bin}/crona", "--version"
  end
end
