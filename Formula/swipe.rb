class Swipe < Formula
  desc "CLI for merchants integrating with the Swipe payment platform"
  homepage "https://github.com/BML-Digital/swipe-merchants-dev"
  url "https://github.com/BML-Digital/swipe-merchants-dev/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "9f1713d1492c4ecf74ec6cf6da1055d98c62503625a02d52fa922f11cadb1c51"
  license "MIT" # TODO: confirm against LICENSE in source repo
  head "https://github.com/BML-Digital/swipe-merchants-dev.git", branch: "main"

  depends_on "go" => :build

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    spec_version = (buildpath/"spec/.spec-version").read.strip
    cd "cli" do
      ldflags = %W[
        -s -w
        -X github.com/BML-Digital/swipe-merchants-dev/cli/internal/version.Version=#{version}
        -X github.com/BML-Digital/swipe-merchants-dev/cli/internal/version.SpecVersion=#{spec_version}
      ].join(" ")
      system "go", "build",
             "-trimpath",
             "-ldflags", ldflags,
             "-o", bin/"swipe",
             "./cmd/swipe"
    end
  end

  test do
    assert_match(/"spec_version"/, shell_output("#{bin}/swipe version --output json"))
  end
end
