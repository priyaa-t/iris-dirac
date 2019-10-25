#!/bin/bash

echo "Print environment details"
echo "============="
printenv
echo "============="

echo "Check host OS"
echo "============="
cat /etc/*release*
echo "============="

echo "Check singularity version"
echo "============="
singularity --version
echo "============="

echo "Check visibility of cvmfs repo"
echo "============="
ls -ltr /cvmfs/sw.skatelescope.eu/images/
echo "============="

echo "Check an image on cvmfs"
echo "============="
singularity exec --cleanenv /cvmfs/sw.skatelescope.eu/images/LOFARSoftwareSarrvesh.simg  wsclean --version
echo "============="

export PATH=/cvmfs/sw.skatelescope.eu/casa/casa-release-5.6.0-60.el7/bin:$PATH
echo "Check cvmfs casa install"
echo "============="
casa --help
echo "============="
