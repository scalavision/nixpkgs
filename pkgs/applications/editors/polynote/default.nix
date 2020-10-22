{
  lib
, python
, virtualenv
, ipython
, nbconvert
, jedi
, numpy
, pandas
, jep
}:
with python.pkgs;
buildPythonApplication rec {

  pname = "polynote";
  version = "0.3.12";

  src = fetchzip {
    url = "https://github.com/${pname}/${pname}/releases/download/${version}/${pname}-dist-2.12.tar.gz";
    sha256 = "1b9w5k0207fysgpxx6db3a00fs5hdc2ncx99x4ccy2s0v5ndc66g";
  };

}