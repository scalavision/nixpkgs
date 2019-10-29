{ stdenv
, buildPerlPackage
, fetchFromGitHub
, htslib
, JSON
, SetIntervalTree
, PerlIOgzip
, DBDmysql
, BioBigFile
, ArchiveZip 
, DBI
, BioDBHTS
, BioDBBigFile
, kent
, mysql 
}:
buildPerlPackage rec {
    pname = "ensemble-vep";
    version = "97.2";
    name = "${pname}-${version}";

    src = fetchFromGitHub  {
        owner = "Ensembl";
        repo = "ensembl-vep";
        rev = "release/${version}";
        sha256 = "0azhzvmh9az9jcq0xprlzdz6w16azgszv4kshb903bwbnqirmk10";  
    };

    propagatedBuildInputs = [
        JSON
        SetIntervalTree
        BioDBBigFile
        PerlIOgzip
        DBDmysql
        BioBigFile
        ArchiveZip 
        DBI
        BioDBHTS
    ];

    buildInputs = [ kent mysql htslib ];
    
}
