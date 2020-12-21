{
  lib
, python
, openjdk
, fetchzip
, makeWrapper
}:

with python.pkgs;
buildPythonApplication rec {

  pname = "polynote";
  version = "0.3.12";

  propagatedBuildInputs = [
    # virtualenv
    ipython
    nbconvert
    jedi
    numpy
    pandas
    openjdk
    jep
  ];

  # checkInputs = [ numpy jep openjdk ];
  doCheck = false;

#  setuptoolsBuildHook = false; 
#  setuptoolsBuildPhase = '' echo skipping '';  

  # dontUseSetuptoolsBuild = true;
 
  prePatch = ''
    cat <<EOF > ./setup.py
    # from distutils.core import setup
    from setuptools import setup

    setup(
        name='${pname}',
        version='${version}',
        scripts=['polynote.py',],
        # packages=find_packages(),
        # install_requires=[ ipython, nbconvert, jedi, numpy, pandas, jep ],
    )
    EOF
    # mkdir ./dist
    # cp ./requirements.txt ./dist
    ls -halt .
  '';

  postInstall = ''
    ls -hatl .
    mkdir -p $out/
    mv ./polynote.jar $out/bin
    mv ./static $out/bin
    mv ./deps $out/bin
    makeWrapper $out/bin/polynote.py \
      $out/bin/polynote \
      --argv0 polynote \
      --set JAVA_HOME ${openjdk}
  '';

  src = fetchzip {
    url = "https://github.com/${pname}/${pname}/releases/download/${version}/${pname}-dist-2.12.tar.gz";
    sha256 = "0xx7s3l1zzakc9427fkqljgpfndj9s9dfmqmbizmdqr12rsfg7z7";
  };

}