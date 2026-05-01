class Tracy < Formula
  desc "Real-time, nanosecond resolution frame profiler (Tenstorrent fork)"
  homepage "https://github.com/wolfpld/tracy"

  # Stable: pinned GitHub archive + checksum (bump via scripts/bump_tracy_formula.py).
  stable do
    url "https://github.com/tenstorrent/tracy/archive/refs/tags/v0.10-tt.0.tar.gz"
    sha256 "9a80bf77190bd66852375ef677751cdbb3e27be2aa1b25c928ea2e7c5b8ae62a"
  end

  # Power users — branch tip (no tarball checksum):
  #   brew install mo-tenstorrent/tools/tracy --HEAD
  #
  # Pin a single commit (edit locally or PR): set revision on head, e.g.
  #   head "https://github.com/tenstorrent/tracy.git", revision: "FULL_SHA_HERE"
  head "https://github.com/tenstorrent/tracy.git", branch: "master"

  license "BSD-3-Clause"

  depends_on "pkgconf" => :build
  depends_on "capstone"
  depends_on "freetype"
  depends_on "glfw"
  depends_on "tbb"

  on_linux do
    depends_on "dbus"
    depends_on "libxkbcommon"
  end

  fails_with gcc: "5" # C++17

  def install
    %w[capture csvexport import-chrome update].each do |f|
      system "make", "-C", "#{f}/build/unix", "release"
      bin.install "#{f}/build/unix/#{f}-release" => "tracy-#{f}"
    end

    system "make", "-C", "profiler/build/unix", "release"
    bin.install "profiler/build/unix/Tracy-release" => "tracy"

    system "make", "-C", "library/unix", "release"
    if File.exist?("library/unix/libtracy-release.dylib")
      lib.install "library/unix/libtracy-release.dylib" => "libtracy.dylib"
    else
      lib.install "library/unix/libtracy-release.so" => "libtracy.so"
    end

    %w[client common tracy].each do |f|
      (include/"Tracy/#{f}").install Dir["public/#{f}/*.{h,hpp}"]
    end
  end

  test do
    assert_match "Tracy Profiler #{version}", shell_output("#{bin}/tracy --help")

    port = free_port
    pid = fork do
      exec "#{bin}/tracy", "-p", port.to_s
    end
    sleep 1
  ensure
    Process.kill("TERM", pid) if pid
    Process.wait(pid) if pid
  end
end
