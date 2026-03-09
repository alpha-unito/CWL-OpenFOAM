#!/bin/bash
#SBATCH --job-name=epito-openfoam
#SBATCH -p epito
# #SBATCH --gpus-per-task=1
#SBATCH -t 04:00:00
#SBATCH -o epito_%j.out
#SBATCH -e epito_%j.err


OF_WORK_PATH=/beegfs/home/gmalenza/src/Workflow-openfoam/workflow-openfoam


export SIF=$OF_WORK_PATH/sif/spuma-a100-aarch.sif

export TMPDIR=/tmp
export OMPI_MCA_tmpdir_base=/tmp
export OMPI_MCA_orte_tmpdir_base=/tmp

export BIND="-B $OF_WORK_PATH:$OF_WORK_PATH -B /proc:/proc -B /sys:/sys -B /dev/shm:/dev/shm "
export OMPI_MCA_btl="tcp,self,vader"
export OMPI_MCA_btl_tcp_if_include=eno1


if [[ $SLURM_NTASKS -eq 1 ]]; then
    singularity exec --nv \
        $BIND \
        $SIF bash -lc "
            source /opt/spuma/etc/bashrc &&
            source /opt/spuma/bin/tools/RunFunctions &&
            {{streamflow_command}}
        " 
else
    mpirun -n $SLURM_NTASKS  \
      singularity exec --nv \
        $BIND \
        $SIF bash -lc "
          source /opt/spuma/etc/bashrc &&
          source /opt/spuma/bin/tools/RunFunctions &&
          {{streamflow_command}}
        "
fi 