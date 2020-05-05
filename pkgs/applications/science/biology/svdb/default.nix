{ lib
, fetchFromGitHub
, python3
}:
with python3.pkgs;
buildPythonApplication rec {

  pname = "svdb";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "J35P312";
    repo = "SVDB";
    rev = version;
    sha256 = "1j7sks7l16g1flf8870qbfa8fwnf4184b721z09kafqw2jb3n4pn";
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
