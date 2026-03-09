#!/bin/bash

#SBATCH -p broadwell
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH -o cavity_cascadelake.log
#SBATCH -e cavity_cascadelake.err
#SBATCH -t 01:00:00



source /beegfs/home/gmalenza/venv-broadwell-stramflow/bin/activate 

export TMPDIR=/beegfs/home/gmalenza/tmp

cd /beegfs/home/gmalenza/src/Workflow-openfoam/workflow-openfoam/src/openfoam-cwl

ulimit -n 65536

streamflow run streamflows/cascadelake/cavity.yml  