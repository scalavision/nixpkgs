# { lib, stdenv, fetchFromGitHub, htslib, zlib, bzip2, lzma, ncurses, boost }:
{ lib, stdenv, fetchFromGitHub, zlib, yacc }:

stdenv.mkDerivation rec {
  pname = "bioawk";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "lh3";
    repo = "bioawk";
    rev = "fd40150b7c557da45e781a999d372abbc634cc21";
    sha256 = "0k81prg9kj7z5fgngsga4sbcwjw03d1mmb4qwg4wsgygl3vk6s2r";
  };

  nativeBuildInputs = [ yacc ];
  buildInputs = [ zlib ];

  installPhase = ''
    ls -halt .
    install -Dm555 ./bioawk $out/bin/bioawk
  '';

}
