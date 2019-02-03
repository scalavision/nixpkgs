{ stdenv, fetchFromGitHub, gradle, perl, openjdk, jre,  makeWrapper }:

let 
  name = "nextflow";
  version = "19.01.0";
  src = fetchFromGitHub {
    owner = "nextflow-io";
    repo = "nextflow";
    rev = "cad871090cf835fe5c51a9c682c01d1f8dd9f5e1";
    sha256 = "06v4knd0gqfcb6wh3lzc14xhq7nnglp1kr5c77mn09p360bllfxn";
  };
 
   # fake build to pre-download deps into fixed-output derivation
  deps = stdenv.mkDerivation {
    name = "${name}-deps";
    inherit src;
    nativeBuildInputs = [ gradle perl ];
    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d)
      
      mkdir -p $out/.nextflow
      export NXF_HOME=$out/.nextflow

      gradle --no-daemon --stacktrace --info build -x test
    '';
    # perl code mavenizes pathes (com.squareup.okio/okio/1.13.0/a9283170b7305c8d92d25aff02a6ab7e45d06cbe/okio-1.13.0.jar -> com/squareup/okio/okio/1.13.0/okio-1.13.0.jar)
    installPhase = ''
      find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh
    '';
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "0xyngz0lgg8x6h6n2q58rf2g8z65bv2ycjy3kgcrw8kh5ph20vmf";
  };

in stdenv.mkDerivation {
  #https://github.com/nextflow-io/nextflow/archive/v19.01.0.tar.gz
  inherit name src;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ perl gradle ];

  # unpackPhase = "true";
  dontConfigure = true;
  # dontBuild = true;

  buildPhase = ''
    echo "### Building main project nextflow"
    export GRADLE_USER_HOME=$(mktemp -d)
    export JAVA_HOME=${openjdk}
    export MAVEN_HOME=${deps}
    export M2_HOME=${deps}
    
    echo "running gradle command, with home dir: $GRADLE_USER_HOME"
    echo $(pwd)

    # point to offline repo
    
    echo "maven repos: $MAVEN_HOME"

    substituteInPlace build.gradle \
      --replace "mavenCentral()" "mavenLocal()" \
      --replace "maven { url 'http://uk.maven.org/maven2' }" "maven { url uri('${deps}') }"
      # --replace "mavenCentral()" "mavenLocal()"

    cat build.gradle | grep uri

    echo "### trying to build with gradle ..."
    
    # make compile
    mkdir -p $out/.nextflow
    export NXF_HOME=$out/.nextflow

    # gradle -Dmaven.repo.local=${deps}  --offline --no-daemon compile -x test
    # gradle -Dmaven.repo.local=${deps}  --offline --no-daemon assemble -x test
    gradle -Dmaven.repo.local=${deps}  --offline --no-daemon packAll -x test

    echo "### Finished building"
    ls -hal

    echo "### Is there a release?"
    echo "build"

    ls -hal build/

    echo "wrapper"

    ls -hal gradle/wrapper

    echo "nextflow"
    ls -hal modules/nextflow

    find . -name "*.jar"

    # make pack
    # gradle --offline --no-daemon build
    #make compile
    #make pack
    #make install
  '';

  installPhase = ''
    runHook preInstall

    # make install
    mkdir -p $out/bin/
    cp build/releases/next* $out/bin/nextflow
    chmod +x $out/bin/nextflow

    wrapProgram $out/bin/nextflow \
      --set JAVA_HOME ${jre}

    runHook postInstall  
  '';

  meta = with stdenv.lib; {
    description = "Data-driven computational pipelines";
    longDescription = ''
    Nextflow enables scalable and reproducible scientific workflows using software containers. 
    It allows the adaptation of pipelines written in the most common scripting languages.
    Its fluent DSL simplifies the implementation and the deployment of complex parallel
     and reactive workflows on clouds and clusters.
    '';
    license = licenses.asl20;
  };
}
