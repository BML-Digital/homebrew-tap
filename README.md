# BML-Digital Homebrew tap

Homebrew formulas for tools published by BML-Digital.

## Install

```sh
brew install BML-Digital/tap/swipe
```

Or, equivalently:

```sh
brew tap BML-Digital/tap
brew install swipe
```

## Formulas

| Formula | Description |
|---------|-------------|
| [`swipe`](Formula/swipe.rb) | CLI for merchants integrating with the Swipe payment platform, with an embedded mock of the Swipe Merchants API. Source: [`swipe-merchants-dev`](https://github.com/BML-Digital/swipe-merchants-dev). |

To upgrade an installed formula:

```sh
brew update
brew upgrade swipe
```

## Maintaining a formula

Formulas in this tap are updated by hand after each release of the
source repository (cross-repo write tokens are restricted under the
org, so the release pipeline does not push here).

The workflow for a new `swipe` release:

1. Tag and release `swipe-merchants-dev` so goreleaser produces the
   per-platform archives and the SHA-256 checksums file. The release
   page will have:
   - `swipe_<version>_darwin_amd64.tar.gz`
   - `swipe_<version>_darwin_arm64.tar.gz`
   - `swipe_<version>_linux_amd64.tar.gz`
   - `swipe_<version>_linux_arm64.tar.gz`
   - `swipe_<version>_checksums.txt`
2. Open `Formula/swipe.rb` in this repo (create it on the very first
   release using the template below).
3. Update the `version` line.
4. For each `on_macos`/`on_linux` × `on_arm`/`on_intel` block, paste in
   the matching `sha256` from the checksums file. The `url` lines
   reference `version` so they update automatically.
5. Commit with a one-line message naming the new version
   (`swipe v0.1.0`) and push to `main`.
6. Smoke-test on a fresh shell:
   ```sh
   brew untap BML-Digital/tap 2>/dev/null
   brew install BML-Digital/tap/swipe
   swipe version
   ```

### `Formula/swipe.rb` template

Use this on the very first release. Subsequent releases edit the
existing file rather than starting from the template.

Notes:

- `license` takes an [SPDX identifier](https://spdx.org/licenses/) —
  e.g. `"MIT"`, `"Apache-2.0"`, `"BSD-3-Clause"`. Set this to whatever
  `swipe-merchants-dev`'s `LICENSE` file declares before tagging the
  first release.
- The `test do` block does more than `--version` (which Homebrew's
  cookbook flags as a weak test) — it invokes a subcommand whose JSON
  output contains an identifiable string.
- The `livecheck` block lets `brew livecheck swipe` find new releases
  by reading the source repo's GitHub releases page.

```ruby
class Swipe < Formula
  desc "CLI for merchants integrating with the Swipe payment platform"
  homepage "https://github.com/BML-Digital/swipe-merchants-dev"
  version "0.0.0"
  license "<SPDX identifier>"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/BML-Digital/swipe-merchants-dev/releases/download/v#{version}/swipe_#{version}_darwin_arm64.tar.gz"
      sha256 "<paste from checksums.txt>"
    end
    on_intel do
      url "https://github.com/BML-Digital/swipe-merchants-dev/releases/download/v#{version}/swipe_#{version}_darwin_amd64.tar.gz"
      sha256 "<paste from checksums.txt>"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BML-Digital/swipe-merchants-dev/releases/download/v#{version}/swipe_#{version}_linux_arm64.tar.gz"
      sha256 "<paste from checksums.txt>"
    end
    on_intel do
      url "https://github.com/BML-Digital/swipe-merchants-dev/releases/download/v#{version}/swipe_#{version}_linux_amd64.tar.gz"
      sha256 "<paste from checksums.txt>"
    end
  end

  def install
    bin.install "swipe"
  end

  test do
    assert_match(/"spec_version"/, shell_output("#{bin}/swipe version --output json"))
  end
end
```

After committing the formula, validate the file locally with:

```sh
brew audit --strict --online Formula/swipe.rb
```

The audit checks that every `url` has a matching `sha256`, the
`homepage` is reachable over HTTPS, the SPDX license is recognised,
and the `livecheck` block can detect the current version.
