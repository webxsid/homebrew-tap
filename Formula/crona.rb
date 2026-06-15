class Crona < Formula
  desc "local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.5.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.5.1/crona-bundle-v1.5.1-darwin-arm64.zip"
      sha256 "f6acb8fd91a17dcc6053dd5c08f6d2ee8d3869737103a8fb51610654e84bf8dc"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.5.1/crona-bundle-v1.5.1-darwin-amd64.zip"
      sha256 "b9c6bf49b01d9075904f4558c84bce49300a81dda913cee73efb7cca4a3895cf"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.5.1/crona-bundle-v1.5.1-linux-arm64.zip"
      sha256 "f70aa7108b773378e2e412ce5190fe22318dd8fa37fbed948a57ba35412fb8ed"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.5.1/crona-bundle-v1.5.1-linux-amd64.zip"
      sha256 "bbeea2bb91f815a9dd5fd15a51f5292da21817800268afb5698b35c6d35d4b2f"
    end
  end
  def install
    bin.install "crona"
    bin.install "crona-kernel"
    bin.install "crona-tui"
  end

  test do
    system "#{bin}/crona", "--version"
  end
end
