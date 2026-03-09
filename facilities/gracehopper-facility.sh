#!/bin/bash
#SBATCH --job-name=gracehopper-openfoam
#SBATCH -p gracehopper
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH -t 04:00:00
#SBATCH -o gracehopper_%j.out
#SBATCH -e gracehopper_%j.err


OF_WORK_PATH=/beegfs/home/gmalenza/src/Workflow-openfoam/workflow-openfoam

export SIF=$OF_WORK_PATH/sif/openfoam-aarch-ompi-4.1.7.sif #openfoam-v2412-aarch-ompi-4.1.7rc1.sif

export TMPDIR=/tmp
export OMPI_MCA_tmpdir_base=/tmp
export OMPI_MCA_orte_tmpdir_base=/tmp

export BIND="-B $OF_WORK_PATH:$OF_WORK_PATH -B /proc:/proc -B /sys:/sys -B /dev/shm:/dev/shm "
export OMPI_MCA_btl="tcp,self,vader"
export OMPI_MCA_btl_tcp_if_include=ens3f1np1



if [[ $SLURM_NTASKS -eq 1 ]]; then
    singularity exec \
        $BIND \
        $SIF bash -lc "
            source /opt/OpenFOAM-v2412/etc/bashrc &&
            source /opt/OpenFOAM-v2412/bin/tools/RunFunctions &&
            {{streamflow_command}}
        " 
else
    mpirun -n $SLURM_NTASKS  \
      singularity exec \
        $BIND \
        $SIF bash -lc "
          source /opt/OpenFOAM-v2412/etc/bashrc &&
          source /opt/OpenFOAM-v2412/bin/tools/RunFunctions &&
          {{streamflow_command}}
        "
fi 