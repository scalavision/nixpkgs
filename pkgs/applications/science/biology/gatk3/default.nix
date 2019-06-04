{ stdenv, fetchFromGitHub, jdk, maven, javaPackages, jre, makeWrapper }:

let
  version = "3.8-1";

  src = fetchFromGitHub {
      owner = "broadgsa";
      repo = "gatk";
      rev = "v${version}";
      sha256 = "0kqp2nvnsb55j1axb6hk0mlw5alyaiyb70z0mdybhpqqxyw2da2r";
  };

  deps = stdenv.mkDerivation {
      name = "gatk3-${version}-deps";
      inherit src;
      buildInputs = [ jdk maven ];
      buildPhase = ''
        while mvn package -Dmaven.repo.local=$out/.m2 -Dmaven.wagon.rto=5000; [ $? = 1]; do
            echo "timeout, restart maven to continue downloading"
        done
      '';

      installPhase = ''find $out/.m2 -type f -regex '.+\(\.lastUpdated\|resolver-status\.properties\|_remote\.repositories\)' -delete'';
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
      outputHash = "1p7yf97dn0nvr005cbs6vdk3i341s8fya4kfccj8qqad2qgxflif";
  };
  in 
  stdenv.mkDerivation rec {

    name = "gatk3-${version}";

    inherit src;

    buildInputs = [ jdk maven ];

    buildPhase = ''
      # 'maven.repo.local' must be writable so copy it out of nix store
      mvn package --offline -Dmaven.repo.local=$(cp -dpR ${deps}/.m2 ./ && chmod +w -R .m2 && pwd)/.m2
    '';

    installPhase = ''
      mkdir -p $out/libexec/gatk3
      cp target/GenomeAnalysisTK.jar $out/libexec/picard/gatk3.jar
      mkdir -p $out/bin
      makeWrapper ${jre}/bin/java $out/bin/gatk3 --add-flags "-jar $out/libexec/gatk3/gatk3.jar"
    '';

    meta = with stdenv.lib; {
      description = "Genome Analysis Toolkit, Variant Discovery in High-Throughput Sequencing Data";
      homepage = https://software.broadinstitute.org/gatk;
      license = licenses.gpl3;
      maintainers = [ maintainers.scalavision ];
      platforms = [ "x86_64-linux" ];
    };

}
