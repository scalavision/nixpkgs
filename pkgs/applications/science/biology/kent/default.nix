{ stdenv
, libpng
, openssl
, fetchFromGitHub
, mysql 
}:
stdenv.mkDerivation rec {
  pname = "kent";
  version = "335";

  src = fetchFromGitHub {
   # https://github.com/ucscGenomeBrowser/kent/archive/v335_base.tar.gz 
   owner = "ucscGenomeBrowser";
   repo = "kent";
   rev = "v${version}_base";
   sha256 = "1455dwzpaq4hyhcqj3fpwgq5a39kp46qarfbr6ms6l2lz583r083";
 };

 buildInputs = [ mysql libpng openssl ];

 buildPhase = ''
   export MACHTYPE=''$(uname -m)
   export CFLAGS="-fPIC"
   export MYSQLINC=`mysql_config --include | sed -e 's/^-I//g'`
   export MYSQLLIBS=`mysql_config --libs`

   cd ./src/lib
   echo 'CFLAGS="-fPIC"' > ../inc/localEnvironment.mk

   make clean && make
   cd ../jkOwnLib
   make clean && make
   cd ../../
 '';

 installPhase = ''
    mkdir -p $out/lib
    ls -hal .
    pwd
    # jkOwnLib.a  jkweb.a  placeHolder.c
    cp ./src/lib/x86_64/jkOwnLib.a $out/lib 
    cp ./src/lib/x86_64/jkweb.a $out/lib
    cp ./src/lib/x86_64/placeHolder.c $out/lib
  ''; 

}
