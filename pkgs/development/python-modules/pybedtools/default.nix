{ lib
, fetchFromGitHub
, fetchPypi
, buildPythonPackage
, bedtools
, zlib
, bzip2
, lzma
, pytest
, cython
, pysam
, pyyaml
, pathlib
, psutil
}:
buildPythonPackage rec {

  pname = "pybedtools";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14w5i40gi25clrr7h4wa2pcpnyipya8hrqi7nq77553zc5wf0df0";
  };

  nativeBuildInputs = [ bedtools ];

  buildInputs = [ zlib bzip2 lzma cython ];

  /*
  preConfigure = ''
    python setup.py cythonise
  '';
  */

  propagatedBuildInputs = [ pysam ];

  checkInputs = [ pytest pyyaml pathlib psutil ];

}

/*
{ lib
, fetchFromGitHub
, buildPythonPackage
, bedtools
, zlib
, bzip2
, lzma
, pytest
, cython
, python3
}:
with python3.pkgs;
buildPythonPackage rec {

  pname = "pybedtools";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "daler";
    repo = "pybedtools";
    rev = "v${version}";
    sha256 = "10c7rj07jz8v7r5yxfpwdx7dqfnrcncp16ry1y2cfk68awdnk122";
  };

  nativeBuildInputs = [ bedtools ];

  postConfigure = ''
    python setup.py cythonize
  '';

  buildInputs = [ zlib bzip2 lzma cython ];

  propagatedBuildInputs = [ pysam ];

  checkInputs = [ pytest ];

}
*/
