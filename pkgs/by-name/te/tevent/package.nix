{
  lib,
  stdenv,
  fetchurl,
  python3,
  pkg-config,
  cmocka,
  readline,
  talloc,
  libxslt,
  docbook-xsl-nons,
  docbook_xml_dtd_42,
  which,
  wafHook,
  buildPackages,
  libxcrypt,
}:

stdenv.mkDerivation rec {
  pname = "tevent";
  version = "0.17.0";

  src = fetchurl {
    url = "mirror://samba/tevent/${pname}-${version}.tar.gz";
    sha256 = "sha256-dwL7Nztp2ilguGE0tqnsb6C5SaAXVv7ACkpqQ1dcg2E=";
  };

  nativeBuildInputs = [
    pkg-config
    which
    python3
    libxslt
    docbook-xsl-nons
    docbook_xml_dtd_42
    wafHook
  ];

  buildInputs = [
    python3
    cmocka
    readline # required to build python
    talloc
    libxcrypt
  ];

  # otherwise the configure script fails with
  # PYTHONHASHSEED=1 missing! Don't use waf directly, use ./configure and make!
  preConfigure = ''
    export PKGCONFIG="$PKG_CONFIG"
    export PYTHONHASHSEED=1
  '';

  wafPath = "buildtools/bin/waf";

  wafConfigureFlags = [
    "--bundled-libraries=NONE"
    "--builtin-libraries=replace"
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "--cross-compile"
    "--cross-execute=${stdenv.hostPlatform.emulator buildPackages}"
  ];

  # python-config from build Python gives incorrect values when cross-compiling.
  # If python-config is not found, the build falls back to using the sysconfig
  # module, which works correctly in all cases.
  PYTHON_CONFIG = "/invalid";

  # https://reviews.llvm.org/D135402
  NIX_LDFLAGS = lib.optional (
    stdenv.cc.bintools.isLLVM && lib.versionAtLeast stdenv.cc.bintools.version "17"
  ) "--undefined-version";

  meta = with lib; {
    description = "Event system based on the talloc memory management library";
    homepage = "https://tevent.samba.org/";
    license = licenses.lgpl3Plus;
    platforms = platforms.all;
  };
}
