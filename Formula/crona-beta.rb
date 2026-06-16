require "fileutils"

class CronaBeta < Formula
  desc "local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.6.0-beta.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.6.0-beta.2/crona-bundle-1.6.0-beta.2-darwin-arm64.zip"
      sha256 "fb78173b500bc2dd594870f8440dd475fbe4f19bc3f8c7e33253385fc9b47abb"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.6.0-beta.2/crona-bundle-1.6.0-beta.2-darwin-amd64.zip"
      sha256 "35aa66119fb415ddae52ecdfb0d2eadf39078500c12dbe695873e1f4546e0725"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.6.0-beta.2/crona-bundle-1.6.0-beta.2-linux-arm64.zip"
      sha256 "d2acd7f72cda7318b96e9e66a6153132bc0a9d545eba11ca75e05fe2b1c11531"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.6.0-beta.2/crona-bundle-1.6.0-beta.2-linux-amd64.zip"
      sha256 "b71931c74efef8d952fc3ec9a5f8035cb23c2352ffffe93f5c07d3c3998d5714"
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
