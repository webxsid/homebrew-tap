require "fileutils"

class Crona < Formula
  desc "Local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.7.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.7.0/crona-bundle-1.7.0-darwin-arm64.zip"
      sha256 "774fead7f636cbce44c30a483fccfbc714958e4196366fc01689304b09a09338"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.7.0/crona-bundle-1.7.0-darwin-amd64.zip"
      sha256 "1bac33fc0707246bccd81025c54942295055d426a9fd1c11e08eea7aaa2ddeff"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.7.0/crona-bundle-1.7.0-linux-arm64.zip"
      sha256 "2eb9532723542941402236d9f5b8778e01ff8a93cd484cddcd0e15cfe8e2e053"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.7.0/crona-bundle-1.7.0-linux-amd64.zip"
      sha256 "1e631cd531260c14dfe58bf619b6505e55d05a4ccc62f3a1fe3882f1c04f9c85"
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
