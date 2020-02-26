{stdenv, fetchFromGitHub, nim, htslib, pcre}:

let
  hts-nim = fetchFromGitHub {
    owner = "brentp";
    repo = "hts-nim";
    rev = "v0.3.2";
    sha256 = "1a2djfq6lbbpwz62q6bafv600dfypkv2gb5bq8x152lvpmhn02v6";
  };

  docopt = fetchFromGitHub {
    owner = "docopt";
    repo = "docopt.nim";
    rev = "v0.6.7";
    sha256 = "1ga7ckg21fzwwvh26jp2phn2h3pvkn8g8sm13dxif33rp471bv37";
  };

in stdenv.mkDerivation rec {
  pname = "mosdepth";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "brentp";
    repo = "mosdepth";
    rev = "v${version}";
    sha256 = "08mm961il17jvhy8cx8v6xhdwwylikmnf12n66x7vr33f9s5mvx4";
  };

  buildInputs = [ nim ];

  buildPhase = ''
    HOME=$TMPDIR
    nim -p:${hts-nim}/src -p:${docopt}/src c --nilseqs:on -d:release mosdepth.nim
  '';
  installPhase = "install -Dt $out/bin mosdepth";
  fixupPhase = "patchelf --set-rpath ${stdenv.lib.makeLibraryPath [ stdenv.cc.cc htslib pcre ]} $out/bin/mosdepth";

  meta = with stdenv.lib; {
    description = "fast BAM/CRAM depth calculation for WGS, exome, or targeted sequencing.";
    license = licenses.mit;
    homepage = https://github.com/brentp/mosdepth;
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.linux;
  };
}
