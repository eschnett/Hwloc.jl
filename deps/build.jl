using BinDeps, Compat
@BinDeps.setup

libhwloc = library_dependency("libhwloc")

# Install via a package manager
@linux_only begin
    provides(AptGet, "libhwloc-dev", libhwloc)
    provides(Yum, "hwloc-devel", libhwloc)
end

@osx_only begin
    using Homebrew
    provides(Homebrew.HB, "hwloc", libhwloc)
end

provides(Binaries, URI("http://www.open-mpi.org/software/hwloc/v1.11/downloads/hwloc-win$WORD_SIZE-build-1.11.0.zip"),
    [libhwloc], unpacked_dir="bin", os = :Windows)

# Build from source
provides(Sources,
         @compat Dict(URI("http://www.open-mpi.org/software/" *
                          "hwloc/v1.11/downloads/hwloc-1.11.0.tar.gz") =>
                      libhwloc))
provides(BuildProcess,
         @compat Dict(Autotools(libtarget="src/libhwloc.la",
                                configure_options=["--without-x"]) => libhwloc))

@compat @BinDeps.install Dict(:libhwloc => :libhwloc)
