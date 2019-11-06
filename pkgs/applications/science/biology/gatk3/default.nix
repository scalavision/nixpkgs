{ stdenv
, fetchurl
, jre
, makeWrapper
}:
let 
  gatkHash = "gf15c1c3ef";
  toolkit = "GenomeAnalysisTK";
in
stdenv.mkDerivation rec {

  name = "gatk3";
  version = "3.8-1-0";

  src = let
    qstring = "package=GATK-archive&version=${version}-${gatkHash}";
  in fetchurl {
    url = "https://software.broadinstitute.org/gatk/download/auth?${qstring}";
    name = "${name}.tar.bz2";
    sha256 = "0p5yikcl54j7krp0sh6vw0wg4zs2a2dlllivpnzkxjnhs8s9b0m0";    
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ jre ];

  phases = [ "unpackPhase"  "installPhase" ];

  unpackPhase = ''
    tar xvf $src
  '';

  installPhase = ''
    mkdir -p $out/libexec/gatk3/
    cp ${toolkit}-${version}-${gatkHash}/${toolkit}.jar $out/libexec/gatk3/${toolkit}.jar
    mkdir $out/bin
    makeWrapper ${jre}/bin/java $out/bin/${toolkit} --add-flags "-jar $out/libexec/gatk3/${toolkit}.jar"
  '';

  meta = with stdenv.lib; {
    description = "Offers a wide variety of tools with a primary focus on DNA variant discovery and genotyping";
    longDescription = ''
      The GATK is the industry standard for identifying SNPs and indels 
      in germline DNA and RNAseq data. In addition to the variant callers themselves, 
      the GATK also includes many utilities to perform related tasks such as 
      processing and quality control of high-throughput sequencing data, 
      and bundles the popular Picard toolkit.
    '';
    license = licenses.mit;
    homepage = "https://github.com/broadgsa/gatk-protected";
    maintainers = with maintainers; [ scalavision ];
    platforms = platforms.all;
  }; 

}
