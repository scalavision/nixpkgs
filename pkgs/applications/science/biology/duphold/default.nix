{ lib, stdenv, fetchFromGitHub, nim, htslib, pcre }:

let
  hts-nim = fetchFromGitHub {
    owner = "brentp";
    repo = "hts-nim";
    rev = "v0.3.8";
    sha256 = "sha256:0if278408ki2sk68nd8l6nik0ch1z6gdxyzj2xbw38n4l4snf40c";
  };

  docopt = fetchFromGitHub {
    owner = "docopt";
    repo = "docopt.nim";
    rev = "v0.6.8";
    sha256 = "sha256:1lw65205illdfyqkjgnad9xg6v7ca802mpzp11nzw1x13n0q0dix";
  };

  unicodedb = fetchFromGitHub {
    owner = "nitely";
    repo = "nim-unicodedb";
    rev = "v0.9.0";
    sha256 = "sha256:06j8d0bjbpv1iibqlmrac4qb61ggv17hvh6nv4pbccqk1rlpxhsq";
  };

  regex = fetchFromGitHub {
    owner = "nitely";
    repo = "nim-regex";
    rev = "v0.19.0";
    sha256 = "sha256:1099gd4l1ypvpg6w9bcxrg1n8nfld3ic7qdnrswdvn6jbw9bkaf1";
  };

  kexpr = fetchFromGitHub {
    owner = "brentp";
    repo = "kexpr-nim";
    rev = "v0.0.2";
    sha256 = "sha256:1arh7as7psyr049dk78svyaax1nggw0d9bchy7l06alvzsbbp8mx";
  };

  genoiser = fetchFromGitHub {
    owner = "brentp";
    repo = "genoiser";
    rev = "v0.2.7";
    sha256 = "sha256:1mw5hg95bjnswajxz4pmz62iz52c6yyzkf4b25aw9m7qnknl1nqy";
  };

in
stdenv.mkDerivation rec {
  pname = "duphold";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "brentp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256:01dqydb7f2vr8pww6vnzqlp63bjhsj3vg4c69waw9hvfdrymh7nb";
  };

  nativeBuildInputs = [ nim ];
  buildInputs = [ htslib pcre ];

  buildPhase = ''
    HOME=$TMPDIR
    nim -p:${hts-nim}/src \
      -p:${unicodedb}/src \
      -p:${regex}/src \
      -p:${docopt}/src \
      -p:${kexpr} \
      -p:${genoiser}/src c --nilseqs:on \
      -d:release src/duphold
  '';

  installPhase = ''
    mv src/duphold .
    install -Dt $out/bin duphold
  '';

  meta = with lib; {
    description = "Add depth information to split-read and discordant read events called by sv callers";
    longDescription = ''
      SV callers like lumpy look at split-reads and pair distances to find structural variants.
      This tool is a fast way to add depth information to those calls.
    
      This can be used as additional information for filtering variants;
    
      for example we will be skeptical of deletion calls that do not have lower
      than average coverage compared to regions with similar gc-content.

      In addition, duphold will annotate the SV vcf with information from a SNP/Indel VCF.
      For example, we will not believe a large deletion that has many heterozygote SNP calls.
    '';
    license = licenses.mit;
    homepage = "https://github.com/brentp/duphold";
    maintainers = with maintainers; [ scalavision ];
    platforms = platforms.linux;
  };
}
