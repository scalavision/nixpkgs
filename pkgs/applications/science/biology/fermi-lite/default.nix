{ stdenv, fetchgit, zlib }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "fermi-lite";
  version = "0.1";

  src = fetchgit {
    url = "https://github.com/lh3/fermi-lite.git";
    rev = "d468f39457124764a7073dd989583813e3353a10";
    sha256 = "0xxsipxikbvdszw6dffnvnbxaxli97vpc9c81aydh8653jq35gfl";
  };
  
  installFlags = "prefix=$(out)";

  buildInputs = [ zlib ];

  enableParallelBuilding = true;

  doCheck = true;

  installPhase = ''
    mkdir -p $out/bin
    cp fml-asm $out/bin/fml-asm
  '';

  meta = with stdenv.lib; {
    description = "Fermi-lite is a standalone C library as well as a command-line tool for assembling Illumina short reads in regions from 100bp to 10 million bp in size";
    license = licenses.mit;
    homepage = https://github.com/lh3/fermi-lite;
    platforms = platforms.unix;
    maintainers = [ maintainers.scalavision ];
  };

}
