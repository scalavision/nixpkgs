{ buildPerlPackage
, fetchFromGitHub
, which
, curl
, BioPerl
, DBI
, DBDmysql
, HTTPTinyish
}:
buildPerlPackage rec {

    version = "104.3";
    pname = "ensembl-vep";
    name = pname + "-" + version;
   # https://github.com/Ensembl/ensembl-vep/archive/release/99.1.tar.gz
    src = fetchFromGitHub {
      owner = "Ensembl";
      repo = pname;
      rev = "release/${version}";
      sha256 = "sha256:1b03cdvb69cxq9swf5h0ln7mgslsj45h4mlgcjxz153zfrmm280j";
    };
    makeMakerFlags = "--NO_UPDATE";
    # --replace "which curl" "${which}/bin/which ${curl}/bin/curl" \
    prePatch = ''

      mv INSTALL.pl Makefile.PL

      cat Makefile.PL | grep curl

      substituteInPlace modules/Bio/EnsEMBL/VEP/Utils.pm \
        --replace "which" "${which}/bin/which"
    '';

    propagatedBuildInputs = [ DBI DBDmysql HTTPTinyish BioPerl ];

}

/*

      substituteInPlace Makefile.PL \
        --replace "update() unless \$NO_UPDATE;" ""

*/