# homebrew-tools

Personal Homebrew tap: **`mo-tenstorrent/tools`**.

```bash
brew tap mo-tenstorrent/tools
brew install tracy
brew upgrade tracy
```

## Tracy (`Formula/tracy.rb`)

Source: **[tenstorrent/tracy](https://github.com/tenstorrent/tracy)** (Tenstorrent fork of wolfpld/tracy).

### Stable (default)

`brew install tracy` builds from a **pinned release tag** tarball with a verified **`sha256`**.

After we publish a new git tag on `tenstorrent/tracy`, bump the formula from this repo:

```bash
cd /path/to/homebrew-tools
./scripts/bump_tracy_formula.py v0.X.Y-tt.N   # tag must exist on GitHub first
git commit -am "tracy: bump stable to v0.X.Y-tt.N"
git push
```

To pin stable to a **specific commit** (same checksum model as a tag):

```bash
./scripts/bump_tracy_formula.py --commit FULL40CHARSHA
```

### Power users

**Branch tip** (no tarball checksum; builds from git):

```bash
brew install mo-tenstorrent/tools/tracy --HEAD
brew reinstall mo-tenstorrent/tools/tracy --HEAD
```

**Exact commit** via git (edit `Formula/tracy.rb`): replace the `head` stanza with:

```ruby
head "https://github.com/tenstorrent/tracy.git", revision: "FULL_SHA"
```

Then `brew install --HEAD mo-tenstorrent/tools/tracy` (or reinstall). Alternatively use **`bump_tracy_formula.py --commit`** to move the **stable** tarball to that SHA instead.
