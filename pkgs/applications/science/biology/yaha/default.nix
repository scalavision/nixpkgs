{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "yaha";
  version = "0.1.83";

  # https://github.com/GregoryFaust/yaha/archive/refs/tags/v0.1.83.tar.gz
  src = fetchFromGitHub {
      owner = "GregoryFaust";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256:18j7f51q2c6mkg4a6wxpqnkvnddgxdd8khmn8ax8v6ivibd5ddja";
  };

  installPhase = ''
    install -Dm555 src/yaha $out/bin/yaha
  '';

  meta = with lib; {
    description = "yaha is a flexible, sensitive and accurate DNA aligner for single-end reads";
    license = licenses.mit;
    maintainers = with maintainers; [ scalavision ];
    platforms = platforms.linux;
  };
}
