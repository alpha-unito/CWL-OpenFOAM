#!/bin/bash

#SBATCH -p broadwell
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH -o epitoAll.log
#SBATCH -e epitoAll.err
#SBATCH -t 06:00:00



source /beegfs/home/gmalenza/venv-login-broadwell/bin/activate

export TMPDIR=/beegfs/home/gmalenza/tmp

cd /beegfs/home/gmalenza/src/Workflow-openfoam/workflow-openfoam

ulimit -n 65536


streamflow run streamflows/epito/cavity.yml   > logs/log.cavity_ep 2>&1                   
streamflow run streamflows/epito/cavity_8M_1node.yml  > logs/log.cavity_8M_1node_ep 2>&1      
streamflow run streamflows/epito/cavity_8M_2node.yml  > logs/log.cavity_8M_2node_ep 2>&1   
streamflow run streamflows/epito/motorbike_1node.yml  > logs/log.motorbike_1node_ep 2>&1 
streamflow run streamflows/epito/motorbike_2node.yml  > logs/log.motorbike_2node_ep 2>&1 
streamflow run streamflows/epito/motorbike_M_1node.yml > logs/log.motorbike_M_1node_ep 2>&1 






