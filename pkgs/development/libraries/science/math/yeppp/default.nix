{ stdenv, fetchurl, python2, openjdk, zlib, lzma, nasm, ant, doxygen }: 

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "yeppp";
  version = "1.0.0";

  src = fetchurl {
      name = "yepp.tar.bz2";
      url = "https://bitbucket.org/MDukhan/yeppp/downloads/${name}.tar.bz2";
      sha256 = "0gacil1xvvpj5vyrrbdyrxxxy74zfdi9rn9jlplx0scrf9pacbh4";
    };

  buildInputs = [ python2 openjdk zlib lzma nasm ant doxygen ];

  installPhase = ''
    mkdir -p $out/include $out/lib
    cp binaries/linux/x86_64/libyeppp.so $out/lib
    cp binaries/linux/x86_64/libyeppp.dbg $out/lib
    cp -R library/headers/*.h $out/include
  '';

}