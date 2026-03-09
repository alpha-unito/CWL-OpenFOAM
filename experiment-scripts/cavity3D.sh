#!/bin/bash

#SBATCH -p broadwell
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH -o cavity3D_allsize.log
#SBATCH -e cavity3D_allsize.err
# #SBATCH --reservation=StreamFlow
# #SBATCH --nodelist=broadwell-000
# #SBATCH -t 24:00:00


echo "Running on host $(hostname)"

source ~/spack/share/spack/setup-env.sh
spack load python@3.13.8 platform=linux os=ubuntu20.04 target=broadwell
source /beegfs/home/gmalenza/venv-login-broadwell/bin/activate
# pip install git+https://github.com/alpha-unito/streamflow.git@add-mounts-to-queue-manager
# pip install git+https://github.com/LanderOtto/wf-viewer.git

export TMPDIR=/beegfs/home/gmalenza/tmp

REPO_DIR=/beegfs/home/gmalenza/src/Workflow-openfoam/workflow-openfoam

cd ${REPO_DIR}

ulimit -n 65536


run_wf() {
    if [ -z "$1" ]; then
        echo "Error: WORKFLOW NAME argument is required."
        echo "Usage: run_wf <workflow_name> <partition> <repo_dir>"
        return 1 
    fi

    if [ -z "$2" ]; then
        echo "Error: PARTITION argument is required."
        echo "Usage: run_wf <workflow_name> <partition> <repo_dir>"
        return 1 
    fi

    case "$2" in
        "broadwell"|"cascadelake"|"epito"|"gracehopper")
            local PARTITION="$2"
            ;;
        *)
            echo "Error: Invalid partition '$2'."
            echo "Valid options are: broadwell, cascadelake, epito, gracehopper"
            return 1
            ;;
    esac

    if [ -z "$3" ]; then
        echo "Error: REPO_DIR argument is required."
        echo "Usage: run_wf <workflow_name> <partition> <repo_dir>"
        return 1 
    fi
    
    local WF_NAME=$1
    local REPO_DIR=$3
    local WF_UNIQUE_NAME=${WF_NAME}-$(date +%s)
    local WORKDIR=${REPO_DIR}/workdir-${PARTITION}
    local REPORT_NAME=${WF_UNIQUE_NAME}_${PARTITION}_report
    local REPORTS_DIR=${REPO_DIR}/reports
    local PLOTS_DIR=${REPO_DIR}/results
    local SF_FILE=${REPO_DIR}/streamflows/${PARTITION}/${WF_NAME}.yaml
    local LOG_FILE=${REPO_DIR}/logs/${WF_NAME}_${PARTITION}.log
    # python -m yappi -o montage-stats.txt -c wall -s \
    #     /beegfs/home/gmalenza/venv-login-broadwell/lib/python3.13/site-packages/streamflow/main.py \
    streamflow \
        run ${SF_FILE} --outdir ${WORKDIR} --name ${WF_UNIQUE_NAME} --debug > ${LOG_FILE} 2>&1 && \
    streamflow report ${WF_UNIQUE_NAME} --file ${SF_FILE} --format json --outdir ${REPORTS_DIR} --name ${REPORT_NAME} >> ${LOG_FILE} 2>&1 && \
    wf-viewer --inputs ${REPORT_NAME}.json --input-type report --wms streamflow --outdir ${PLOTS_DIR} --filename ${REPORT_NAME} --format png --group-by task --save-stats >> ${LOG_FILE} 2>&1
}


# run_wf "cavity3D" "broadwell" ${REPO_DIR}
run_wf "cavity3D" "cascadelake" ${REPO_DIR}
# run_wf "cavity3D" "epito" ${REPO_DIR}
# run_wf "cavity3D" "gracehopper" ${REPO_DIR}
# run_wf "cavity3D" "hybrid" ${REPO_DIR}




