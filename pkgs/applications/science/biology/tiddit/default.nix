{ lib
, fetchFromGitHub
, cmake
, zlib
, python36
, bash
}:

with python36.pkgs;
buildPythonApplication rec {

  pname = "TIDDIT";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "SciLifeLab";
    repo = "${pname}";
    rev = "${pname}-${version}";
    sha256 = "1awqjh076b5a63sd2349fzqadip7dy7bl6g73a3p8l6ijv3wkr6m";
  };

  nativeBuildInputs = [ cmake bash ];
  buildInputs = [ zlib ];
  propagatedBuildInputs = [ numpy cython ];

  # The build directory seems to already have been created by nix
  # overwriting this line with the path to bash.
  prePatch = ''
    substituteInPlace INSTALL.sh \
      --replace "mkdir build" "#!${bash}/bin/bash"
  '';

  buildPhase = ''
    cd ../
    ./INSTALL.sh
    cd ./src
  '';

  # No tests available
  checkPhase = false;

  # This is called even if checkPhase is false
  dontUsePipInstall = true;

  installPhase = ''
    cd ../

    mkdir -p $out/bin/bin
    mkdir -p $out/lib

    mv ./src $out/bin/
    mv ./lib $out/bin/

    cp TIDDIT.py $out/bin
    install -Dm555 ./bin/TIDDIT $out/bin/bin/TIDDIT

    BAMTOOLS="./build/lib/bamtools/src/api"
    cp $BAMTOOLS/libbamtools.a $out/lib
    cp $BAMTOOLS/libbamtools.so  $out/lib
    cp $BAMTOOLS/libbamtools.so.2.3.0 $out/lib
  '';

  # Other way to override?
  setuptoolsCheckPhase = ''
    echo "No tests available"
  '';

  postInstall = ''
    rm -rf $out/bin/src/build
  '';

  meta = with lib; {
    homepage = "https://github.com/SciLifeLab/TIDDIT";
    description = "Structural variant caller for mapped DNA sequenced data";
    license = licenses.gpl3;
    longDescription = ''
    TIDDIT: Is a tool to used to identify chromosomal rearrangements using 
    Mate Pair or Paired End sequencing data. 
    TIDDIT identifies intra and inter-chromosomal translocations, deletions, 
    tandem-duplications and inversions, using supplementary alignments 
    as well as discordant pairs.  
    '';
    maintainers = with maintainers; [ scalavision ];
  };

}
