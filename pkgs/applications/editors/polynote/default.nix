{ lib, python, openjdk8, fetchzip, makeWrapper }:

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
    openjdk8
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
        install_requires=[ 'ipython', 'nbconvert', 'jedi', 'numpy', 'pandas', 'jep' ],
    )
    EOF
    # mkdir ./dist
    # cp ./requirements.txt ./dist
    ls -halt .

    echo "patching"
    substituteInPlace ./config-template.yml \
      --replace '#  port: 8192' "  port: 8193"
    cat ./config-template.yml | grep port
  '';

  postInstall = ''
    ls -halt .
    mkdir -p $out/bin
    cp ./config-template.yml $out/bin/config.yml
    mv ./polynote.jar $out/bin
    mv ./static $out/bin
    mv ./deps $out/bin
    cp ${jep}/lib/python3.8/site-packages/jep/jep-3.9.1.jar $out/bin/deps
    ln -s ${jep}/lib/python3.8/site-packages/jep $out/lib/python3.8/site-packages
    makeWrapper $out/bin/polynote.py \
      $out/bin/polynote \
      --argv0 polynote \
      --set JAVA_HOME ${openjdk8} \
      --set LD_LIBRARY_PATH ${jep}/lib/python3.8/site-packages/jep \
      --set CLASSPATH ${jep}/lib/python3.8/site-packages/jep/jep-3.9.1.jar

  '';

  src = fetchzip {
    url =
      "https://github.com/${pname}/${pname}/releases/download/${version}/${pname}-dist-2.12.tar.gz";
    sha256 = "0xx7s3l1zzakc9427fkqljgpfndj9s9dfmqmbizmdqr12rsfg7z7";
  };

}
