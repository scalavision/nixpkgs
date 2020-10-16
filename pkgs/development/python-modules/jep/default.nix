{ stdenv
, numpy
, openjdk
, fetchFromGitHub
, python3
}: 

python3.pkgs.buildPythonPackage rec {
  pname = "jep";
  version = "3.9.1";
  src = fetchFromGitHub {
    owner = "ninia";
    repo = pname;
    rev = "v${version}";
    sha256 = "0pf7jxpj0g5b139s5jghqhjak57r9axyv08ywc77q38xj7m9fjld";
  };

  propagatedBuildInputs = [ numpy ];

  buildInputs = [ openjdk ];

  checkInputs = [ numpy ];

  /*
  installPhase = ''
    ls -halt .
    ls -halt ./dist
    ls -halt ./build

    mkdir -p $out/bin/scripts-3.8
    mv ./build/scripts-3.8/jep $out/bin
    
    mkdir -p $out/include
    mv ./build/include/*.h $out/include

    mkdir -p $out/lib
    mv ./build/lib.linux-x86_64-3.8/* $out/lib

    mkdir -p $out/java
    mv ./build/java/jep-${version}.jar $out/java
  '';
  */

}