#!/bin/bash

#SBATCH -p broadwell
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH -o moto_allsize.log
#SBATCH -e moto_allsize.err
# #SBATCH --nodelist=broadwell-000
# #SBATCH -t 24:00:00
# #SBATCH --reservation=StreamFlow


echo "Running on host $(hostname)"

source ~/spack/share/spack/setup-env.sh
spack load python@3.13.8 platform=linux os=ubuntu20.04 target=broadwell
source /beegfs/home/gmalenza/venv-login-broadwell/bin/activate
# pip install git+https://github.com/alpha-unito/streamflow.git@add-mounts-to-queue-manager
# pip install git+https://github.com/LanderOtto/wf-viewer.git

export TMPDIR=/beegfs/home/gmalenza/tmp

cd /beegfs/home/gmalenza/src/Workflow-openfoam/workflow-openfoam

ulimit -n 65536



run_wf() {
    if [ -z "$1" ]; then
        echo "Error: WORKFLOW NAME argument is required."
        echo "Usage: run_wf <workflow_name> <partition>"
        return 1 
    fi

    if [ -z "$2" ]; then
        echo "Error: PARTITION argument is required."
        echo "Usage: run_wf <workflow_name> <partition>"
        return 1 
    fi

    case "$2" in
        "broadwell"|"cascadelake"|"epito"|"gracehopper"|"hybrid")
            local PARTITION="$2"
            ;;
        *)
            echo "Error: Invalid partition '$2'."
            echo "Valid options are: broadwell, cascadelake, epito, gracehopper"
            return 1
            ;;
    esac

    local WF_NAME=$1
    local WF_UNIQUE_NAME=${WF_NAME}-$(date +%s)
    local WF_OF_REPO=/beegfs/home/gmalenza/src/Workflow-openfoam/workflow-openfoam/
    local WORKDIR=./workdir-${PARTITION}
    local REPORT_NAME=report-${PARTITION}-${WF_UNIQUE_NAME}
    local REPORT_OUTDIR=logs
    python -m yappi -o montage-stats.txt -c wall -s \
        /beegfs/home/gmalenza/venv-login-broadwell/lib/python3.13/site-packages/streamflow/main.py \
        run ${WF_OF_REPO}/streamflows/${PARTITION}/${WF_NAME}.yaml --outdir ${WORKDIR} --name ${WF_UNIQUE_NAME} --debug > logs/${WF_NAME}_${PARTITION}.log 2>&1 && \
    streamflow report ${WF_UNIQUE_NAME} --format json --outdir ${WORKDIR} --name ${REPORT_NAME} >> logs/${WF_NAME}_${PARTITION}.log && \
    wf-viewer --inputs ${REPORT_NAME}.json --input-type report --wms streamflow --outdir ${REPORT_OUTDIR} --filename report-${PARTITION} --format png --group-by task --save-stats
}


run_wf "motorbike_AllSizes_1node" "hybrid"
        





