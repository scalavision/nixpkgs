{ stdenv
, numpy
, openjdk
, fetchFromGitHub
, buildPythonPackage
, pkgs
, makeWrapper
}: 
pkgs.python3Packages.buildPythonPackage rec {
  pname = "jep";
  version = "3.9.1";
  src = fetchFromGitHub {
    owner = "ninia";
    repo = pname;
    rev = "v${version}";
    sha256 = "0pf7jxpj0g5b139s5jghqhjak57r9axyv08ywc77q38xj7m9fjld";
  };

  propagatedBuildInputs = [ numpy ];

  buildInputs = [ openjdk makeWrapper ];

  checkInputs = [ numpy ];
  
  postInstall = ''
    rm $out/bin/jep
    cat << EOF > $out/bin/jep
    export PYTHONPATH="$PYTHONPATH":$out/lib/python3.8/site-packages
    java -Djava.library.path=$out/lib/python3.8/site-packages/jep \
      -cp $out/lib/python3.8/site-packages/jep/jep-3.9.1.jar jep.Run "$${@}"
    EOF
#    chmod +x $out/bin/jep
  '';

}
