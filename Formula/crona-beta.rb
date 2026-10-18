require "fileutils"

class CronaBeta < Formula
  desc "Local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.10.0-beta.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.10.0-beta.2/crona-bundle-1.10.0-beta.2-darwin-arm64.zip"
      sha256 "59115e910ed8fa12ad9454e52fc52a71c31398638cac4918433fabf7b79493c2"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.10.0-beta.2/crona-bundle-1.10.0-beta.2-darwin-amd64.zip"
      sha256 "32964c1c4afced33daccbf11033258e1baa76ddd107d04311663d88e4b710945"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.10.0-beta.2/crona-bundle-1.10.0-beta.2-linux-arm64.zip"
      sha256 "62904d626440e639e11808f6a3682f11316c37d9df7e12d566171c33a4c7e0e7"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.10.0-beta.2/crona-bundle-1.10.0-beta.2-linux-amd64.zip"
      sha256 "3e88d00afa6a81942d9e4f6cd1c9fbaae5534f5ccb6f38e4ec704c15c0e0a75c"
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
