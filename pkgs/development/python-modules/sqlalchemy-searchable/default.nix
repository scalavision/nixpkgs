{ lib
, buildPythonPackage
, fetchPypi
, sqlalchemy
, sqlalchemy-utils
, validators
, python
, python3Packages
}:
buildPythonPackage rec {

  pname = "SQLAlchemy-Searchable";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zgpfnyicp5blx05rwh3jr0yf8p4vqm8kgp77f5hm2kf6p8yjzar";
  };

  propagatedBuildInputs = [
    sqlalchemy sqlalchemy-utils python3Packages.validators
  ];
  
  checkInputs = with python3Packages; [
    pytest
    psycopg2
#    psycopg2cffi
    flake8
    isort
  ];

  checkPhase = ''
    pytest tests
  '';
  
  # tests are not packaged in pypi tarball
  # doCheck = false;

  # pythonImportsCheck = [ "citext" ];

  meta = with lib; {
    description = "A sqlalchemy plugin that allows postgres use of CITEXT";
    homepage = "https://github.com/mahmoudimus/sqlalchemy-citext";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
  
}
