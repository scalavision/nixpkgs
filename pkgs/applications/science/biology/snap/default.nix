{ lib
, stdenv
, zlib
, fetchFromGitHub
}:
stdenv.mkDerivation rec {
  pname = "snap";
  version = "c7f89b5b3263f95d1988295961ff2c20ff78441c";
  
  src = fetchFromGitHub {
    owner = "amplab";
    repo = pname;
    rev = version;
    sha256 = "16mbwc04mxq9106083jzqlxbka373182rk63kk9irx92qkdbigvy";
  };

  buildInputs = [ zlib ];

  hardeningDisable = [ "all" ];

  installPhase = ''
    runHook preInstall
    install -Dm555 ./snap-aligner $out/bin/snap-aligner
    install -Dm555 ./SNAPCommand $out/bin/SNAPCommand
    runHook postInstall
  '';

}