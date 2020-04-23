{ lib
, fetchFromBitbucket
, python36
, bedtools
, rPackages
, R
}:
with python36.pkgs;
buildPythonApplication rec {

  pname = "intervene";
  version = "0.6.1";

  src = fetchFromBitbucket {
    owner = "CBGR";
    repo = "intervene";
    rev = "master";
    sha256 = "14nnsf755klzbhrgvah1v62bxigw92jgb7yqk9bml7f4naxvvrzh";
  };

#  buildInputs = [ bedtools ];
  propagatedBuildInputs = [  bedtools rPackages.UpSetR rPackages.corrplot rPackages.Cairo pybedtools pandas seaborn R ];

  meta = with lib; {
    homepage = "https://github.com/J35P312/SVDB";
    description = "SVDB, genomic structural variant database";
    license = licenses.gpl3;
    longDescription = ''
    SVDB is a toolkit for constructing and querying structural
    variant databases. The databases are constructed using the
    output vcf files from structural variant callers such as
    TIDDIT, Manta, Fermikit or Delly. SVDB may also be used to
    merge SV vcf files from multiple callers or individuals.
    '';
    maintainers = with maintainers; [ scalavision ];
  };

}

/*
{ lib
, fetchFromGitHub
, python3
}:
with python3.pkgs;
buildPythonApplication rec {

  pname = "svdb";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "J35P312";
    repo = "SVDB";
    rev = version;
    sha256 = "14nnsf755klzbhrgvah1v62bxigw92jgb7yqk9bml7f4naxvvrzi";
  };

  patches = [ ./0001-set-language-version.patch ];

  buildInputs = [ cython ];
  propagatedBuildInputs = [ numpy ];

  meta = with lib; {
    homepage = "https://github.com/J35P312/SVDB";
    description = "SVDB, genomic structural variant database";
    license = licenses.gpl3;
    longDescription = ''
    SVDB is a toolkit for constructing and querying structural
    variant databases. The databases are constructed using the
    output vcf files from structural variant callers such as
    TIDDIT, Manta, Fermikit or Delly. SVDB may also be used to
    merge SV vcf files from multiple callers or individuals.
    '';
    maintainers = with maintainers; [ scalavision ];
  };

}
*/
