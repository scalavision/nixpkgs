{ stdenv
, callPackage
, ...
} @ args:

callPackage ./generic.nix (rec{
  version = "1.9";
  sha256 = "10ilqbmm7ri8z431sn90lvbjwizd0hhkf9rcqw8j823hf26nhgq8";
} // args )
