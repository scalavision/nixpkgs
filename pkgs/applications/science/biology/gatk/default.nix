{ stdenv
, fetchurl
, jre
, unzip
, python3
, makeWrapper
, gcc
}:
stdenv.mkDerivation rec {
  name = "gatk";
  version = "4.1.6.0";

  src = fetchurl {
    url = "https://github.com/broadinstitute/gatk/releases/download/${version}/gatk-${version}.zip";
    sha256 = "01n3jhk8hyk21djr88vn5by2n62amm5xmdl77nw1y3iwd5b052hs";
  };

  nativeBuildInputs = [ makeWrapper unzip ];

  buildInputs = [ jre python3 gcc ];

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/libexec
    mkdir -p $out/bin
    unzip $src -d $out/libexec

    makeWrapper $out/libexec/gatk-${version}/gatk $out/bin/gatk  \
      --prefix PATH : $out/libexec/gatk-${version} \
      --prefix PATH : ${python3}/bin \
      --prefix PATH : ${jre}/bin \
      --prefix LD_LIBRARY_PATH : ${gcc.cc.lib}/lib \
      --set GATK_LOCAL_JAR $out/libexec/gatk-${version}/gatk-package-${version}-local.jar
  '';

  meta = with stdenv.lib; {
    description = "Offers a wide variety of tools with a primary focus on DNA variant discovery and genotyping";
    longDescription = ''
      The industry standard for identifying SNPs and indels in germline
      DNA and RNAseq data. Its scope is now expanding to include somatic
      short variant calling, and to tackle copy number (CNV) and structural variation (SV).
      In addition to the variant callers themselves, the GATK also includes many utilities
      to perform related tasks such as processing and quality control of high-throughput
      sequencing data, and bundles the popular Picard toolkit.
    '';
    license = licenses.bsd3;
    homepage = "https://software.broadinstitute.org/gatk/";
    maintainers = with maintainers; [ scalavision ];
    platforms = platforms.all;
  };
}
