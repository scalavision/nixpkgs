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

    version = "99.1";
    pname = "ensembl-vep";
    name = pname + "-" + version;
   # https://github.com/Ensembl/ensembl-vep/archive/release/99.1.tar.gz
    src = fetchFromGitHub {
      owner = "Ensembl";
      repo = pname;
      rev = "release/${version}";
      sha256 = "1jajxdbmjv0nrim54p28mm6cpsr0c8wnc2adzgn2413qk36dsll1";
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