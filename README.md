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

`brew install tracy` builds from a **pinned release tag** tarball with a verified **`sha256`** (currently **`v0.13.3-tt.0-test`**, CMake profiler GUI).

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

## Tracy experimental (`Formula/tracy-experimental.rb`)

Git-only **CMake `profiler/`** build. Conflicts with **`tracy`** (both install `tracy`).

Without env vars the formula uses **`master`**, which may **not** include **`profiler/CMakeLists.txt`** on this fork.

**Important:** Homebrew **drops** most variables before formula code runs. Use **`HOMEBREW_TRACY_EXPERIMENTAL_BRANCH`** (see [Formula Cookbook – env vars](https://docs.brew.sh/Formula-Cookbook#using-environment-variables)). Plain **`TRACY_EXPERIMENTAL_BRANCH` is usually stripped**, which looks like “I set it but brew still used master”.

```bash
HOMEBREW_TRACY_EXPERIMENTAL_BRANCH=mo/9691_tracy_gui_new brew install mo-tenstorrent/tools/tracy-experimental
HOMEBREW_TRACY_EXPERIMENTAL_BRANCH=mo/9691_tracy_gui_new brew reinstall mo-tenstorrent/tools/tracy-experimental --build-from-source
```

Implementation: **`install` deletes the staged clone and downloads `archive/refs/heads/<branch>.tar.gz`** (slashes → `%2F`).

Stale cache: **`brew fetch --force tracy-experimental`**, then reinstall **with** the env var prefix again.

If you see **`Warning: No remote 'origin' in .../homebrew-tracy`**, remove or repair that tap: **`brew untap mmemarian/homebrew-tracy`** (or `git remote add origin …` in that tap directory).
