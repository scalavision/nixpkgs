{ stdenv
, callPackage
, ...
}@args:

callPackage ./generic.nix (rec {
  version = "1.10";
  sha256 = "119ms0dpydw8dkh3zc4yyw9zhdzgv12px4l2kayigv31bpqcb7kv";
} //args )
