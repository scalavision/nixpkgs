{  stdenv
, fetchFromGitHub
, makeWrapper
, zlib
, perl
, perlPackages
, curl
, which
, unzip 
}:

let 

    version = "99.1";

   # https://github.com/Ensembl/ensembl-vep/archive/release/99.1.tar.gz
    src = fetchFromGitHub {
      owner = "Ensembl";
      repo = "ensembl-vep";
      rev = "release/${version}";
      sha256 = "1jajxdbmjv0nrim54p28mm6cpsr0c8wnc2adzgn2413qk36dsll1";
    };

    deps = stdenv.mkDerivation {
        
        name = "ensembl-vep-${version}-dep";

        inherit src;

        propagatedBuildInputs = [ perl perlPackages.DBI perlPackages.DBDmysql perlPackages.HTTPTinyish curl which unzip ];
        
        buildInput = [ curl ];

        nativeBuildInputs = [ zlib makeWrapper curl ];

        buildPhase = ''
            echo "skipping build Phase"
        '';

        patchPhase = ''
            echo "patching INSTALL.pl"

            cat INSTALL.pl | grep curl  
            
            substituteAllInPlace INSTALL.pl \
              --replace "curl" ${curl}/bin/curl \
              --replace "$CAN_USE_CURL      = 1 if `which curl` =~ /\/curl/;" "$CAN_USE_CURL      = 1"

            cat INSTALL.pl | grep curl  

            echo "Was it patched"

        '';

        installPhase = ''
            echo "Running perl install script"

            export PATH=$PATH/${curl}/bin

            echo "TESTING CURL"
            curl --help

            ls -hal ${curl}/bin

            perl INSTALL.pl
        '';
    };

in
stdenv.mkDerivation rec {
    
    name = "ensemple-vep-${version}";

    inherit src;

    makeFlags = [ "PREFIX=$(out)/bin" ];
    
    preInstall = "mkdir -p $out/bin";

    propagatedBuildInputs = [ perl perlPackages.DBI ];
    
    nativeBuildInputs = [ zlib makeWrapper ];

    buildPhase = ''
        mkdir -p $out/bin
        mkdir -p $out/lib
        cp -R ${deps} $out/lib
    '';

    postFixup = ''
        wrapProgram $out/bin/vep --prefix PERL5LIB : $PERL5LIB --prefix VEPLIB: $out/lib
    '';


}
