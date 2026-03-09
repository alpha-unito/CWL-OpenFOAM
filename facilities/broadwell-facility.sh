#!/bin/bash
#SBATCH --job-name=broadwell-openfoam
#SBATCH -p broadwell
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH -t 04:00:00
#SBATCH -o broadwell_%j.out
#SBATCH -e broadwell_%j.err


OF_WORK_PATH=/beegfs/home/gmalenza/src/Workflow-openfoam/workflow-openfoam

export SIF=$OF_WORK_PATH/sif/openfoam_v2412_sandbox_broadwell

export TMPDIR=/tmp
export OMPI_MCA_tmpdir_base=/tmp
export OMPI_MCA_orte_tmpdir_base=/tmp

export BIND="-B $OF_WORK_PATH:$OF_WORK_PATH -B /proc:/proc -B /sys:/sys -B /dev/shm:/dev/shm "
export OMPI_MCA_btl="tcp,self,vader"
export OMPI_MCA_btl_tcp_if_include="eno2"

source ~/spack/share/spack/setup-env.sh
spack load singularityce@4.1.0

ulimit -n 65535

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