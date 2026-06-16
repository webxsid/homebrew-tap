require "fileutils"

class CronaBeta < Formula
  desc "local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.6.0-beta.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.6.0-beta.2/crona-bundle-1.6.0-beta.2-darwin-arm64.zip"
      sha256 "7e61a01c0e88ea05c70554da78a425879c3289539dd0b4f4df0b93aa0ce3302a"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.6.0-beta.2/crona-bundle-1.6.0-beta.2-darwin-amd64.zip"
      sha256 "cedcfd23eea2abc7f977c8354d542864e0c442575e27ce821a713d963bb6c87a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.6.0-beta.2/crona-bundle-1.6.0-beta.2-linux-arm64.zip"
      sha256 "02041fed1e445ace001095cdeb1b38fa0385170283b01b1d87e726dbd32512e7"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.6.0-beta.2/crona-bundle-1.6.0-beta.2-linux-amd64.zip"
      sha256 "d0be94bd05bc0a2dca7421a61d435757d8eca20836b3adbfb531228963ba67c6"
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
