#!/bin/bash

#SBATCH -p broadwell
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH -o cavity_broadwell.log
#SBATCH -e cavity_broadwell.err
#SBATCH -t 01:00:00



source /beegfs/home/gmalenza/venv-broadwell-stramflow/bin/activate 


export TMPDIR=/beegfs/home/gmalenza/tmp

cd /beegfs/home/gmalenza/src/Workflow-openfoam/workflow-openfoam/src/openfoam-cwl

ulimit -n 65536

streamflow run streamflows/broadwell/cavity_8M_1node.yml --outdir ./workdir-broadwell > logs/log_cavity_8M_brodwell.log 2>&1

streamflow run streamflows/broadwell/motorbike_M_1node.yml --outdir ./workdir-motorbike-broadwell > logs/log_motorbike_M_broadwell.log 2>&1
