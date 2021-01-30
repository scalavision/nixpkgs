{ lib, python3, openjdk8, fetchFromGitHub }:
with python3.pkgs;
buildPythonApplication rec {
  pname = "jep";
  version = "3.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jy0h7aqrsy8mnis9328m2rxdm6w1ccl0sbn9r8938qr5aljbkbw";
  };
  
  propagatedBuildInputs = [
    numpy
  ];

  buildInputs = [ openjdk8 ];
  
  doCheck = false;
  #checkInputs = [ pytest ];

  postFixup = ''
    cat <<EOF > $out/bin/jep
    #!/bin/sh

    VIRTUAL_ENV=
    export VIRTUAL_ENV

    LD_LIBRARY_PATH=${python3}/lib:${python3}/lib/python3.8/site-packages:$out/lib/python3.8/site-packages/jep; export LD_LIBRARY_PATH
    LD_PRELOAD="${python3}/lib/libpython3.8.so"; export LD_PRELOAD

    if test "x\$VIRTUAL_ENV" != "x"; then
      PATH="\$VIRTUAL_ENV/bin:\$PATH"
      export PATH
    fi

    cp="$out/lib/python3.8/site-packages/jep/jep-3.9.1.jar"
    if test "x\$CLASSPATH" != "x"; then
        cp="\$cp":"\$CLASSPATH"
    fi

    jni_path="$out/lib/python3.8/site-packages/jep"

    args=\$*
    if test "x\$args" = "x"; then
      args="$out/lib/python3.8/site-packages/jep/console.py"
    fi

    exec java -classpath "\$cp" -Djava.library.path="\$jni_path" jep.Run \$args
    EOF
  '';

  meta = with lib; {
    homepage = "https://github.com/ninia/jep/wiki";
    description = "Jep embeds CPython in Java through JNI.";
    longDescription = ''
      Some benefits of embedding CPython in a JVM:
        - Using the native Python interpreter may be much faster than alternatives.
        - Python is mature, well supported, and well documented.
        - Access to high quality Python modules, both native CPython extensions and Python-based.
        - Compilers and assorted Python tools are as mature as the language.
        - Python is an interpreted language, enabling scripting of established Java code without requiring recompilation.
        - Both Java and Python are cross platform, enabling deployment to different operating systems.
    '';
    license = licenses.zlib;
    maintainers = with maintainers; [ scalavision ];
  };
}
