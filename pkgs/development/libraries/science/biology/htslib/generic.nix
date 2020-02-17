{ stdenv, fetchurl, zlib, bzip2, lzma, curl, perl, version, sha256, ... }:
stdenv.mkDerivation rec {
  pname = "htslib";
  inherit version;
  src = fetchurl {
    url = "https://github.com/samtools/htslib/releases/download/${version}/${pname}-${version}.tar.bz2";
    inherit sha256;
  };

  # perl is only used during the check phase.
  nativeBuildInputs = [ perl ];

  buildInputs = [ zlib bzip2 lzma curl ];

  configureFlags = [ "--enable-libcurl" ]; # optional but strongly recommended

  installFlags = [ "prefix=$(out)" ];

  preCheck = ''
    patchShebangs test/
  '';

  enableParallelBuilding = true;

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A C library for reading/writing high-throughput sequencing data";
    license = licenses.mit;
    homepage = http://www.htslib.org/;
    platforms = platforms.unix;
    maintainers = [ maintainers.mimame ];
  };
}
