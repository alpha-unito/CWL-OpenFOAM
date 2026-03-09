#!/bin/bash

#SBATCH -p broadwell
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH -o cavity_gracehopper.log
#SBATCH -e cavity_gracehopper.err
#SBATCH -t 01:00:00



source /beegfs/home/gmalenza/venv-broadwell-stramflow/bin/activate 

export TMPDIR=/beegfs/home/gmalenza/tmp

cd /beegfs/home/gmalenza/src/Workflow-openfoam/workflow-openfoam/src/openfoam-cwl

ulimit -n 65536

streamflow run streamflows/gracehopper/cavity_8M_1node.yml --outdir ./workdir-gracehopper > logs/log_cavity_8M_gracehopper.log 2>&1

