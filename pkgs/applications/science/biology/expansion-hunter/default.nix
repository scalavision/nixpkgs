{ stdenv, fetchFromGitHub, cmake, zlib }:

stdenv.mkDerivation rec {
  pname = "ExpansionHunter";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "Illumina";
    repo = pname;
    rev = "v${version}";
    sha256 = "159qrjfa1g9nzf1cr4m2mjx09l9qrw7j1v08sn2z38nl6wd9q5xc";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib ];
  /*
  postFixup = ''
    sed -i 's|/usr/bin/env python2|${python2.interpreter}|' $out/lib/python/makeRunScript.py
    sed -i 's|/usr/bin/env python|${python2.interpreter}|' $out/lib/python/pyflow/pyflow.py
    sed -i 's|/bin/bash|${stdenv.shell}|' $out/lib/python/pyflow/pyflowTaskWrapper.py
    '';
    */
    doInstallCheck = true;

  meta = with stdenv.lib; {
    description = "Structural variant caller";
    license = licenses.gpl3;
    homepage = "https://github.com/Illumina/manta";
    maintainers = with maintainers; [ jbedo ];
    platforms =  platforms.x86_64;
  };
}
