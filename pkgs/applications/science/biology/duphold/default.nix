{stdenv, fetchFromGitHub, nim, htslib, pcre}:

let
  hts-nim = fetchFromGitHub {
    owner = "brentp";
    repo = "hts-nim";
    rev = "v0.3.4";
    sha256 = "0670phk1bq3l9j2zaa8i5wcpc5dyfrc0l2a6c21g0l2mmdczffa7";
  };

  docopt = fetchFromGitHub {
    owner = "docopt";
    repo = "docopt.nim";
    rev = "v0.6.7";
    sha256 = "1ga7ckg21fzwwvh26jp2phn2h3pvkn8g8sm13dxif33rp471bv37";
  };

  genoiser = fetchFromGitHub {
    owner = "brentp";
    repo = "genoiser";
    rev = "v0.2.7";
    sha256 = "1mw5hg95bjnswajxz4pmz62iz52c6yyzkf4b25aw9m7qnknl1nqy";
  };

  keyexpr = fetchFromGitHub {
    owner = "brentp";
    repo = "kexpr-nim";
    rev = "7302245f8dafb33f4ecf9861fd81ceb4d7b193c8";
    sha256 = "1arh7as7psyr049dk78svyaax1nggw0d9bchy7l06alvzsbbp8mx";
  };

in stdenv.mkDerivation rec {
  pname = "duphold";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "brentp";
    repo = "duphold";
    rev = "v${version}";
    sha256 = "172xkb7q061wv3aqzayn1ii4l7gwjsyplwli93b9dhvgqwcqb41r";
  };

  buildInputs = [ nim ];

  prePatch = ''
    substituteInPlace ./duphold.nimble --replace "import ospaths" "import os"
  '';

  # nim -p:${hts-nim}/src -p:${docopt}/src -p:${genoiser} c --nilseqs:on -d:release duphold.nimble
  buildPhase = ''
    HOME=$TMPDIR
    nim -p:${hts-nim}/src -p:${docopt}/src -p:${keyexpr}/src -p:${genoiser}/src c --nilseqs:on -d:release src/duphold.nim
  '';
  installPhase = "install -Dt $out/bin duphold";
  fixupPhase = "patchelf --set-rpath ${stdenv.lib.makeLibraryPath [ stdenv.cc.cc htslib pcre ]} $out/bin/duphold";

  meta = with stdenv.lib; {
    description = "scalable, depth-based annotation and curation of high-confidence structural variant calls";
    license = licenses.mit;
    homepage = "https://github.com/brentp/duphold";
    maintainers = with maintainers; [ scalavision ];
    platforms = platforms.linux;
  };
}
