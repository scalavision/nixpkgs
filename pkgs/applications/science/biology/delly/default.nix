{ stdenv, fetchgit, htslib, zlib, bzip2, lzma, ncurses, boost }:

stdenv.mkDerivation rec {

    name = "${pname}-${version}";
    pname = "delly";
    version = "0.7.9";

    src = fetchgit {
        url = "https://github.com/dellytools/delly.git";
        rev = "1da97218e5324c00acb2bb33b0e7985fad4d8079";
        sha256 = "0ip6x1g5dr7j8w3qhvg4d1p4ix88mcx0jjb01zsnaaxq3gbh3b09";
    };

    buildInputs = [ zlib htslib bzip2 lzma ncurses boost ];

    postUnpack = ''
        echo "${htslib}"
        ls -hal
        cp ${htslib.src} src/htslib
        # ls -hal ${htslib.out}
        cp ${htslib.out}/lib/libhts.so.1.9 src/htslib
    '';

    buildPhase = ''
        make
    '';

    installPhase = ''
        mkdir -p $out/bin
        # TODO: also add a path to the htslib, in RPATH, otherwise probably everything is good
        cp src/delly $out/bin/delly    
        export PATH=$PATH:$out/bin/delly
    '';

}
