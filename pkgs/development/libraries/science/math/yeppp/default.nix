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

  # buildInputs = [ python2 openjdk zlib lzma nasm ant doxygen ];

  installPhase = ''
    mkdir -p $out/include $out/lib
    cp binaries/linux/x86_64/libyeppp.so $out/lib
    cp binaries/linux/x86_64/libyeppp.dbg $out/lib
    cp -R library/headers/*.h $out/include
  '';

  meta = with stdenv.lib; {
    description = "Yeppp! is a high-performance SIMD-optimized mathematical library for x86, ARM, and MIPS processors.";
    longDescription = ''
      Yeppp! contains versions of its functions for multiple architectures and instruction 
      sets and chooses the optimal implementation during initialization to guarantee the 
      best performance on the host machine. Besides basic arithmetic operations 
      (addition, subtraction, multiplication) Yeppp! provides high-performance mathematical 
      functions, such as log, exp, sin, which operate on vectors.
    '';
    license = licenses.bsd3;
    maintainers = [ maintainers.scalavision ];
    platforms = platforms.linux;
  };
}

