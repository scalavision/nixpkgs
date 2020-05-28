{ stdenv
, fetchFromBitbucket
, nasm
, openjdk8
}:
stdenv.mkDerivation rec {

  pname = "yeppp";
  version = "1.0.0";

  src = fetchurl {
    url = "";
  }; 
  
  /*
  src = fetchFromBitbucket {
    owner = "MDukhan";
    repo = pname;
    rev = "default";
     sha256 = "1xgzlmqz7lw1p4lf87jczjqq6c22l4x61mdwxrxgcij27lhnh2rj";
  };*/

  buildInputs = [ nasm openjdk8 ];

  buildPhase = ''
    pushd ./runtime
    make x64-linux-sysv-default
    popd 
    java -jar ./CLIBuild.jar x64-linux-sysv-default
  '';

}