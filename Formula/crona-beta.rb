require "fileutils"

class CronaBeta < Formula
  desc "Local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.9.0-beta.8"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.9.0-beta.8/crona-bundle-1.9.0-beta.8-darwin-arm64.zip"
      sha256 "5f71b458e7c39e222bb052e4434460dc70b3ac4f09d6be361a2907c18fd0a2e4"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.9.0-beta.8/crona-bundle-1.9.0-beta.8-darwin-amd64.zip"
      sha256 "51382f781c6fe996f16bd92eadfc01f1f680b13c3ebbdfff0929167fdd00d76a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.9.0-beta.8/crona-bundle-1.9.0-beta.8-linux-arm64.zip"
      sha256 "d93732f3a15231c10312ad5070ae628015176aefe07ffb2493d99165e7aa7cf3"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.9.0-beta.8/crona-bundle-1.9.0-beta.8-linux-amd64.zip"
      sha256 "9aedab86342cd324c3398fd1430021975e61d620a97fb7178b156733ae853f07"
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
      "{\n  \"installSource\": \"" + source + "\",\n  \"brewFormula\": \"" + formula_name + "\",\n  \"releaseChannel\": \"beta\"\n}\n",
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
    write_install_source("brew", "crona-beta")
  end
  test do
    system "#{bin}/crona", "--version"
    system "#{bin}/crona-daemon", "--version"
  end
end
