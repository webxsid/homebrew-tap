require "fileutils"

class CronaBeta < Formula
  desc "local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.6.0-beta.1"

  on_macos do
    if Hardware::CPU.arm?
      url "file:///home/runner/work/crona/crona/release/v1.6.0-beta.1/crona-bundle-v1.6.0-beta.1-darwin-arm64.zip"
      sha256 "8ea8f3408b078f68a6eea7ea01e2902f2a38a03d4d9a302866b3adf071e317b3"
    else
      url "file:///home/runner/work/crona/crona/release/v1.6.0-beta.1/crona-bundle-v1.6.0-beta.1-darwin-amd64.zip"
      sha256 "e1b1f59dcb37cbccfd9988b45f1952b4c2969ff92c4dabae1bf8aed588b72be7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "file:///home/runner/work/crona/crona/release/v1.6.0-beta.1/crona-bundle-v1.6.0-beta.1-linux-arm64.zip"
      sha256 "edc6fd9d6f5eb5a2bda210ea09c6ebec106d329d9a9b04aaea12c82cba15fa24"
    else
      url "file:///home/runner/work/crona/crona/release/v1.6.0-beta.1/crona-bundle-v1.6.0-beta.1-linux-amd64.zip"
      sha256 "5858dda18baaed85972c608ef10faa33fde638ae5b6024024a717500661c8536"
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
        bin.install "crona-v1.6.0-beta.1-darwin-arm64" => "crona"
        bin.install "crona-kernel-v1.6.0-beta.1-darwin-arm64" => "crona-kernel"
        bin.install "crona-tui-v1.6.0-beta.1-darwin-arm64" => "crona-tui"
      else
        bin.install "crona-v1.6.0-beta.1-darwin-amd64" => "crona"
        bin.install "crona-kernel-v1.6.0-beta.1-darwin-amd64" => "crona-kernel"
        bin.install "crona-tui-v1.6.0-beta.1-darwin-amd64" => "crona-tui"
      end
    elsif OS.linux?
      if Hardware::CPU.arm?
        bin.install "crona-v1.6.0-beta.1-linux-arm64" => "crona"
        bin.install "crona-kernel-v1.6.0-beta.1-linux-arm64" => "crona-kernel"
        bin.install "crona-tui-v1.6.0-beta.1-linux-arm64" => "crona-tui"
      else
        bin.install "crona-v1.6.0-beta.1-linux-amd64" => "crona"
        bin.install "crona-kernel-v1.6.0-beta.1-linux-amd64" => "crona-kernel"
        bin.install "crona-tui-v1.6.0-beta.1-linux-amd64" => "crona-tui"
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
