{ 
  stdenv
, fetchFromGitHub
, cmake
, zlib
, htslib
, google-test
}:
stdenv.mkDerivation rec {

  pname = "expansionhunter";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "Illumina";
    repo = "ExpansionHunter";
    rev = "v${version}";
    sha256 = "13ciwskxinxpchp69bic0r5mv235h0jca1n7w4symvcvd6dlj0j8";
  };

  nativeBuildInputs = [ cmake google-test ];
  buildInputs = [ zlib htslib ];

  meta = with stdenv.lib; {
    description = "repeat size estimator";
    license = licenses.gpl3;
    homepage = "https://github.com/Illumina/ExpansionHunter";
    maintainers = with maintainers; [ scalavision ];
    platforms =  platforms.x86_64;
  };
}
