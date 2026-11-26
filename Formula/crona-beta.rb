require "fileutils"

class CronaBeta < Formula
  desc "Local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.10.0-beta.10"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/crona-app/crona/releases/download/v1.10.0-beta.10/crona-bundle-1.10.0-beta.10-darwin-arm64.zip"
      sha256 "1617b31ceb5d5c037b668796f2d6b33875c38edc4a95b5133fe3d94b95e4fb77"
    else
      url "https://github.com/crona-app/crona/releases/download/v1.10.0-beta.10/crona-bundle-1.10.0-beta.10-darwin-amd64.zip"
      sha256 "405429e632ef611bc5ca6c2c1049914e70e0ab2022413872c640b32ec3d58d6c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/crona-app/crona/releases/download/v1.10.0-beta.10/crona-bundle-1.10.0-beta.10-linux-arm64.zip"
      sha256 "80317039efa8b9f86a1412beb36e883a924c5cc9fd67e70d3a8ff511bd033d72"
    else
      url "https://github.com/crona-app/crona/releases/download/v1.10.0-beta.10/crona-bundle-1.10.0-beta.10-linux-amd64.zip"
      sha256 "8b88b176b26ba3cc46d3733b1c67472170570c0122d361365bc6d5562d0a6be6"
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
