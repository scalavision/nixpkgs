{ lib
, buildPythonPackage
, pytest
, pysam
, numpy
, scipy
, cytoolz
, pytestrunner
, fetchurl
, requests
, click
, pyyaml
, progress
, humanfriendly
, s3cmd
}:

buildPythonPackage rec {
  
  pname = "tsd-api-client";
  version = "1.8.3";
  
  # TODO: use fetchPyPi but with the git address
  # fetchPypi { url = ...};
  src = fetchurl {
    url = "https://github.com/unioslo/tsd-api-client/archive/v1.8.3.tar.gz";
    sha256 = "03igzbnxwaj1cvjfbqajfkg7f5x7i5mwkffjiigyhqlcpfqxbzh4";
    # fetchSubmodules = true;
  };

#  checkInputs = false; #[ pytest pytestrunner ];

  /*
  requests
click
pyyaml
https://github.com/leondutoit/s3cmd/archive/v20180312.tar.gz
progress
humanfriendly

  */

  # humanfriendly 
  propagatedBuildInputs = [ requests humanfriendly click pyyaml progress s3cmd ];

  meta = with lib; {
    homepage = https://github.com/hall-lab/svtyper;
    description = "A data description language";
    license = licenses.mit;
    maintainers = with maintainers; [ scalavision ];
  };

}


