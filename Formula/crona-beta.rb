require "fileutils"

class CronaBeta < Formula
  desc "local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.6.1-beta.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.6.1-beta.1/crona-bundle-1.6.1-beta.1-darwin-arm64.zip"
      sha256 "70e5b02389ed69ea3d475aa20617488baaa2aa15993b9caf0942fe6acb530a52"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.6.1-beta.1/crona-bundle-1.6.1-beta.1-darwin-amd64.zip"
      sha256 "fb376b2194275c6c4f3aa12991722f2e65941f9517b0ea41ef691b4469bef335"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.6.1-beta.1/crona-bundle-1.6.1-beta.1-linux-arm64.zip"
      sha256 "7d933b9bc81b01f9067d5b69fe8643fc62cb9a0a922ca406a34e7a42f8e6c089"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.6.1-beta.1/crona-bundle-1.6.1-beta.1-linux-amd64.zip"
      sha256 "f3803604539808426ccd6bb5530103940df08557de3bb85ddc70653c060872bb"
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
