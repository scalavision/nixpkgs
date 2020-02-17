{ stdenv
, callPackage
, ...
}@args:

callPackage ./generic.nix (rec {
  version = "1.9";
  sha256 = "16ljv43sc3fxmv63w7b2ff8m1s7h89xhazwmbm1bicz8axq8fjz0";
} //args )
