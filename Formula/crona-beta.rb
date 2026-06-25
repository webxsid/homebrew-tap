require "fileutils"

class CronaBeta < Formula
  desc "local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.6.1-beta.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.6.1-beta.2/crona-bundle-1.6.1-beta.2-darwin-arm64.zip"
      sha256 "6446ae8abbd5850185ca641a22ee99821aef5c6333a3fbffa15096009135143b"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.6.1-beta.2/crona-bundle-1.6.1-beta.2-darwin-amd64.zip"
      sha256 "569aa9c8d7fa7af09b164d4c79fcd627cd39bc605f4053643334411de8d68910"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.6.1-beta.2/crona-bundle-1.6.1-beta.2-linux-arm64.zip"
      sha256 "060c0d132cf2eda9db55d5cfe002f7187eb9c855e66488c39944af06bcebc5b9"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.6.1-beta.2/crona-bundle-1.6.1-beta.2-linux-amd64.zip"
      sha256 "1afeb8cbad25a101b9d56335dbbbd8b87f36d01bde47c2a096d7b03e927737d7"
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
