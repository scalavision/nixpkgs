{ stdenv, fetchgit, ldc, zlib }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "biod";
  version = "0.2.2";

  src = fetchgit {
      url = "https://github.com/biod/BioD.git";
      rev = "418ab75da17b52f4b9fea64ee56d39c1d327a150";
      sha256 = "0bi6rx83cw8lh5dd6dhzpfcbcp0xswavx5a1mzmp9axq6gl85hd3";
  };

  buildInputs = [ ldc zlib ];

  configureFlags = [ "--enable-gold" "--no-grafts" ];

  enableParallelBuilding = true;

  doCheck = true;

  buildPhase = ''
    make -j 4
    make check
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp -R bio/* $out/lib/.
  '';

}