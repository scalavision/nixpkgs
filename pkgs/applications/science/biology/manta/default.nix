{ stdenv, pkgconfig, cmake, doxygen, zlib, boost, fetchFromGitHub, python27, makeWrapper }: 
stdenv.mkDerivation rec {

    name = "manta";
    version = "1.5.0";

    src = fetchFromGitHub {
      owner = "Illumina";
      repo = "manta";
      rev = "v${version}";
      sha256 = "0fh9z3lscpd24jaxgsy338icp0zxqz7l7k4iy366cb03b4vxmv7s";
    };

    nativeBuildInputs = [ pkgconfig cmake makeWrapper ];

    buildInputs = [ doxygen boost boost.out boost.dev python27 zlib zlib.dev ];

    preConfigure = ''
      substituteInPlace ./src/cmake/boost.cmake \
        --replace "set (DEBUG_FINDBOOST FALSE)" "set (DEBUG_FINDBOOST TRUE)" \
        --replace "set (THIS_BOOST_VERSION 1.58.0)" "set (THIS_BOOST_VERSION 1.59.0)" \

      export BOOST_INCLUDEDIR=${boost.dev}/include/boost/
      export BOOST_LIBRARYDIR="${boost}/lib"
    '';
    
    # installPhase = ''
    #   mkdir -p "$out/bin" 
    #   install -Dm555 "$src" "$out/bin/.configManta-wrapped"
    #   makeWrapper "$out/bin/.configManta-wrapped"  "$out/bin/configManta.py" --prefix PATH: ${stdenv.lib.makeBinPath [ python27 ]}
    # '';

    postInstall = ''
        mkdir -p "$out/lib/python"
        export PYTHONPATH=$PYTHONPATH:$out/lib/python
        CURRENT_DATE=$(date --iso-8601=seconds)
        cat > $out/lib/python/configBuildTimeInfo.py <<EOL
#
# Manta - Structural Variant and Indel Caller
# Copyright (c) 2013-2018 Illumina, Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#

"""
This consolidates build-time config data such as git status
and build date. This is in contrast to cmake configuration-time
config data like relative paths and library/header availability.
"""

workflowVersion="${version}"
buildTime="$CURRENT_DATE"
EOL
'';

}