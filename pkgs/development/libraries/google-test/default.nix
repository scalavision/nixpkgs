{
  stdenv,
  cmake,
  fetchFromGitHub
}:

stdenv.mkDerivation rec {

  pname = "google-test";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "release-${version}";
    sha256 = "1zbmab9295scgg4z2vclgfgjchfjailjnvzc6f5x9jvlsdi3dpwz";
  };

  buildInputs = [ cmake ];

}