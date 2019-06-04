{ stdenv, ldc, fetchgit, zlib, biod, htslib, lzma, vim, python3, which }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "sambamba";
  version = "0.7.0";

  src = fetchgit {
    url = "https://github.com/biod/sambamba";
    rev = "8fc9a378b2f9fb584392b4d54efc511dcfc1abc7";
    sha256 = "1523sppfpczaqh62af3sjapc0h10dzvhbzx06zgj3f13kwfbhy32";
  };

  nativeBuildInputs = [ python3 which ];

  buildInputs = [ zlib ldc htslib vim biod lzma vim ];

  enableParallelBuilding = true;

  preBuild = ''
    echo "updating path to biod lib"

    substituteInPlace ./Makefile \
      --replace BioD ${biod.src}

    # python3 ./gen_ldc_version_info.py ${ldc}/bin/ldmd2 > ./sambamba/utils/ldc_version_info_.d
    # echo "FINISHED GENERATING THE LDC VERSION INFO"
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Sambamba is a high performance highly parallel robust and fast tool (and library), written in the D programming language, for working with SAM and BAM files.";
    license = licenses.gpl2;
    homepage = https://github.com/biod/sambamba;
    platforms = platforms.unix;
    maintainers = [ maintainers.scalavision ];
  };
}
