{ stdenv, fetchurl, zlib, htslib, perl, ncurses ? null, version, sha256, ... }:

stdenv.mkDerivation rec {
  pname = "samtools";
  inherit version;
  src = fetchurl {
    url = "https://github.com/samtools/samtools/releases/download/${version}/${pname}-${version}.tar.bz2";
    inherit sha256;
  };

  nativeBuildInputs = [ perl ];

  buildInputs = [ zlib ncurses htslib ];

  configureFlags = [ "--with-htslib=${htslib}" ]
    ++ stdenv.lib.optional (ncurses == null) "--without-curses";

  preCheck = ''
    patchShebangs test/
  '';

  enableParallelBuilding = true;

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Tools for manipulating SAM/BAM/CRAM format";
    license = licenses.mit;
    homepage = http://www.htslib.org/;
    platforms = platforms.unix;
    maintainers = [ maintainers.mimame ];
  };
}
