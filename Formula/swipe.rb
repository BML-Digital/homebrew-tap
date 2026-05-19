class Swipe < Formula
  desc "CLI for merchants integrating with the Swipe payment platform"
  homepage "https://github.com/BML-Digital/swipe-merchants-dev"
  url "https://github.com/BML-Digital/swipe-merchants-dev/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
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
