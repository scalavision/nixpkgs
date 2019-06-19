{ stdenv, fetchFromGitHub, makeWrapper, zlib, perl, perlPackages }:

stdenv.mkDerivation rec {

    version = "96.3";
    name = "ensembl-vep";

    # TODO: Need to download all dependencies in an outer src block
    # TODO: Then you can use that downloaded stuff to actually do the installation
    
    src = fetchFromGitHub {
        owner = "Ensembl";
        repo = name;
        rev = "release/${version}";
        sha256 = "0nm1227f025f5wdi58ny2nxhjfrl0n2zq2qys91p96bxszwcc935";
    };

    propagatedBuildInputs = [ perl perlPackages.DBI ];

    nativeBuildInputs = [ zlib makeWrapper ];

    makeFlags = [ "PREFIX=$(out)/bin" ];

    preInstall = "mkdir -p $out/bin";

    buildPhase = ''
        echo "skipping build Phase"
    '';

    installPhase = ''
        
        perl INSTALL.pl
    '';

    postFixup = ''
        wrapProgram $out/bin/vep --prefix PERL5LIB : $PERL5LIB
    '';

}