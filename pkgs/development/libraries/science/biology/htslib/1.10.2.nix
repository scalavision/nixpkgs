{ stdenv
, callPackage
, ...
} @ args:
callPackage ./generic.nix ( args // rec {
  version = "1.10.2";
  sha256 = "0f8rglbvf4aaw41i2sxlpq7pvhly93sjqiz0l4q3hwki5zg47dg3";
} )
