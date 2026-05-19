# This formula is a placeholder until the first release of
# swipe-merchants-dev is tagged. To activate it:
#
#   1. Tag and release `BML-Digital/swipe-merchants-dev` so goreleaser
#      produces the per-platform archives + checksums.txt.
#   2. Update `version` below to the released version (no leading `v`).
#   3. Replace every `0000...` sha256 with the matching value from
#      `swipe_<version>_checksums.txt`.
#   4. If the source repo's LICENSE differs from MIT, update `license`
#      to the matching SPDX identifier (https://spdx.org/licenses/).
#   5. `brew audit --strict --online Formula/swipe.rb`.
#   6. Commit + push to `main`.

class Swipe < Formula
  desc "CLI for merchants integrating with the Swipe payment platform"
  homepage "https://github.com/BML-Digital/swipe-merchants-dev"
  version "0.0.0"
  license "MIT" # TODO: confirm against LICENSE in source repo

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/BML-Digital/swipe-merchants-dev/releases/download/v#{version}/swipe_#{version}_darwin_arm64.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
    on_intel do
      url "https://github.com/BML-Digital/swipe-merchants-dev/releases/download/v#{version}/swipe_#{version}_darwin_amd64.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BML-Digital/swipe-merchants-dev/releases/download/v#{version}/swipe_#{version}_linux_arm64.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
    on_intel do
      url "https://github.com/BML-Digital/swipe-merchants-dev/releases/download/v#{version}/swipe_#{version}_linux_amd64.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  def install
    bin.install "swipe"
  end

  test do
    assert_match(/"spec_version"/, shell_output("#{bin}/swipe version --output json"))
  end
end
