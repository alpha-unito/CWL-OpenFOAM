#!/bin/bash

#SBATCH -p broadwell
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH -o cavity_epito.log
#SBATCH -e cavity_epito.err
#SBATCH -t 01:00:00



source /beegfs/home/gmalenza/venv-broadwell-stramflow/bin/activate 

export TMPDIR=/beegfs/home/gmalenza/tmp

cd /beegfs/home/gmalenza/src/Workflow-openfoam/workflow-openfoam/src/openfoam-cwl

ulimit -n 65536

streamflow run streamflows/epito/cavity_8M_1node.yml --outdir ./workdir-epito > logs/log_cavity_8M_epito.log 2>&1

streamflow run streamflows/epito/motorbike_M_1node.yml --outdir ./workdir-motorbike-epito > logs/log_motorbike_M_epito.log 2>&1

