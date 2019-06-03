{ stdenv, autoreconfHook, fetchgit, zlib, samtools, cmake, htslib, bzip2, lzma, curl, perl }:

stdenv.mkDerivation rec {
  name = "${pname}-v${version}";
  pname = "lumpy";
  version = "0.3.0";

  src = fetchgit {
    url = "https://github.com/arq5x/lumpy-sv.git";
    rev = "800c67ca5b454d01e7019bdcdda63e11ff7b3968";
    sha256 = "1r6sssbnz017jpnsfb6dfjj0y7bzxgxxdikz4rak569m6kqkawqq";
  };
  
  installFlags = "prefix=$(out)";

  buildInputs = [ zlib bzip2 lzma curl autoreconfHook cmake ];

  enableParallelBuilding = true;

  doCheck = true;

  preconfigurePhase = ''
    export ZLIB_PATH=${zlib}
  '';

  installPhase = ''
    mkdir -p $out/bin
    ls -hal .
    cp -R bin/* $out/
  '';

  meta = with stdenv.lib; {
    description = "Fermi-lite is a standalone C library as well as a command-line tool for assembling Illumina short reads in regions from 100bp to 10 million bp in size";
    license = licenses.mit;
    homepage = https://github.com/lh3/fermi-lite;
    platforms = platforms.unix;
    maintainers = [ maintainers.scalavision ];
  };

}
