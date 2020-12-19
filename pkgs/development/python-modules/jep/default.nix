{ stdenv
# , numpy
, openjdk
, python3
#, fetchFromGitHub
# , buildPythonPackage
# , pkgs
, makeWrapper
}: 
# pkgs.python3Packages.buildPythonPackage rec {
with python3.pkgs;
buildPythonPackage rec {

  pname = "jep";
  version = "3.9.1";

  /* 
  src = fetchFromGitHub {
    owner = "ninia";
    repo = pname;
    rev = "v${version}";
    sha256 = "0pf7jxpj0g5b139s5jghqhjak57r9axyv08ywc77q38xj7m9fjld";
  };
  */

  src = fetchPypi {
    inherit pname version; 
    sha256 = "1jy0h7aqrsy8mnis9328m2rxdm6w1ccl0sbn9r8938qr5aljbkbw";
    # sha256 = "0pf7jxpj0g5b139s5jghqhjak57r9axyv08ywc77q38xj7m9fjle";
  };

  propagatedBuildInputs = [ numpy ];

  buildInputs = [ openjdk makeWrapper ];

  # checkInputs = [ pytest numpy ];
  doCheck = false;
  
  /* 
  postInstall = ''
    rm $out/bin/jep
    cat << EOF > $out/bin/jep
    export PYTHONPATH="$PYTHONPATH":$out/lib/python3.8/site-packages
    java -Djava.library.path=$out/lib/python3.8/site-packages/jep \
      -cp $out/lib/python3.8/site-packages/jep/jep-3.9.1.jar jep.Run "$${@}"
    EOF
#    chmod +x $out/bin/jep
  '';
  */

  /*
  postInstall = ''
    mv $out/bin/jep $out/bin/.jep-wrapped
    makeWrapper $out/bin/.jep-wrapped "$out/bin/jep" \
      --prefix PATH : "${openjdk}/bin" \
      --set JAVA_HOME "${openjdk}"
  '';
  */
}
