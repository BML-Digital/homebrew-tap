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

## Maintaining the formula

`swipe` is currently distributed as a build-from-source formula
(Homebrew installs Go as a `:build` dependency and runs `go build`).
This keeps the release workflow simple: no per-platform archives, no
checksums file — just one source tarball per release.

When prebuilt binary releases ship later (likely via `goreleaser`),
this formula will switch over to the multi-platform `on_macos`/`on_linux`
URL+SHA pattern.

### Updating to a new release

1. Tag the new version on `BML-Digital/swipe-merchants-dev`
   (e.g. `git tag -a v0.2.0 -m "..." && git push origin v0.2.0`).
2. Compute the source-tarball SHA-256:
   ```sh
   curl -sL https://github.com/BML-Digital/swipe-merchants-dev/archive/refs/tags/v0.2.0.tar.gz \
     | shasum -a 256
   ```
3. In `Formula/swipe.rb`, update both the `url` (the version segment)
   and `sha256` to the new values.
4. Run `brew audit --strict --online Formula/swipe.rb`.
5. Commit with a one-line message (`swipe v0.2.0`) and push to `main`.
6. Smoke-test on a fresh shell:
   ```sh
   brew untap BML-Digital/tap 2>/dev/null
   brew install BML-Digital/tap/swipe
   swipe version
   ```

### Why build-from-source for now

- One artifact per release (the auto-generated source tarball from
  GitHub), one checksum to update.
- No release pipeline / cross-compilation infrastructure required.
- Go is already a prerequisite the project documents; Homebrew managing
  it as a build dep keeps end-user steps to one command.

The cost is slower `brew install` (compile time) and a build-time Go
dependency. Both are acceptable until binary releases land.
