# Build-from-source formula. To activate on the first release:
#
#   1. Tag and push v0.1.0 (or later) on `BML-Digital/swipe-merchants-dev`.
#   2. Compute the source-tarball checksum:
#        curl -sL https://github.com/BML-Digital/swipe-merchants-dev/archive/refs/tags/v0.1.0.tar.gz | shasum -a 256
#   3. Update `url` (replace v0.1.0) and `sha256` below with that value.
#   4. If the source repo's LICENSE differs from MIT, update `license`
#      to the matching SPDX identifier (https://spdx.org/licenses/).
#   5. `brew audit --strict --online Formula/swipe.rb` should pass.
#   6. Commit + push to `main`.
#
# Until then, `brew install BML-Digital/tap/swipe` will fail because
# v0.1.0 doesn't yet exist on the source repo. `brew install
# --head BML-Digital/tap/swipe` will build from `main`.

class Swipe < Formula
  desc "CLI for merchants integrating with the Swipe payment platform"
  homepage "https://github.com/BML-Digital/swipe-merchants-dev"
  url "https://github.com/BML-Digital/swipe-merchants-dev/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
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
