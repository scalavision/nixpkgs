{ stdenv, fetchFromGitHub, nim}:
stdenv.mkDerivation rec {
  pname = "kexpr-nim";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "brentp";
    repo = "kexpr-nim";
    rev = "7302245f8dafb33f4ecf9861fd81ceb4d7b193c8";
    sha256 = "1arh7as7psyr049dk78svyaax1nggw0d9bchy7l06alvzsbbp8mx";
  };

  buildInputs = [ nim ];

  buildPhase = ''
    HOME=$TMPDIR
    nimble install kexpr
  '';
  installPhase = "install -Dt $out/bin kexpr";

  #fixupPhase = "patchelf --set-rpath ${stdenv.lib.makeLibraryPath [ stdenv.cc.cc htslib pcre ]} $out/bin/duphold";

  meta = with stdenv.lib; {
    description = "nim wrapper for Heng Li's math expression library";
    license = licenses.mit;
    homepage = "https://github.com/brentp/duphold";
    maintainers = with maintainers; [ scalavision ];
    platforms = platforms.linux;
  };

}
