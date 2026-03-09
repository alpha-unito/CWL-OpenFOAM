#!/bin/bash

#SBATCH -p broadwell
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH -o cavity_broadwell.log
#SBATCH -e cavity_broadwell.err
#SBATCH -t 06:00:00

source ~/spack/share/spack/setup-env.sh
spack load singularityce@4.1.0

source /beegfs/home/gmalenza/venv-login-broadwell/bin/activate

export TMPDIR=/beegfs/home/gmalenza/tmp

cd /beegfs/home/gmalenza/src/Workflow-openfoam/workflow-openfoam

ulimit -n 65536


streamflow run streamflows/broadwell/cavity.yml   > logs/log.cavity_bd 2>&1                   
streamflow run streamflows/broadwell/cavity_8M_1node.yml  > logs/log.cavity_8M_1node_bd 2>&1      
streamflow run streamflows/broadwell/cavity_8M_2node.yml  > logs/log.cavity_8M_2node_bd 2>&1   
streamflow run streamflows/broadwell/motorbike_1node.yml  > logs/log.motorbike_1node_bd 2>&1 
streamflow run streamflows/broadwell/motorbike_2node.yml  > logs/log.motorbike_2node_bd 2>&1 
streamflow run streamflows/broadwell/motorbike_M_1node.yml > logs/log.motorbike_M_1node_bd 2>&1 






