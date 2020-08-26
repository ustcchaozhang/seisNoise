#!/bin/bash

# parameters
velocity_dir=$1
compute_adjoint=$2
SUBMIT_DIR=$3
SCRIPTS_DIR=$4
SUBMIT_RESULT=$5
WORKING_DIR=$6



source $SUBMIT_DIR/parameter

###############################################
#################################################
# Submit directory

#isource=$(($PBS_VNODENUM))
iproc=$SLURM_PROCID
iproc0=1
if [ $iproc -lt $NSRC ] && [ $iproc -ge 0 ]; then
    isource=$(echo $(echo "$iproc $iproc0" | awk '{print $1+$2}'))
    echo "isource="$isource
fi

###############################################

cd $SUBMIT_DIR


##############################################


    # STEP one -- forward simulation
    STARTTIME=$(date +%s)
    data_tag='DATA_syn'

    if $compute_adjoint ; then   
        SAVE_FORWARD=true
    else
        SAVE_FORWARD=false
    fi

    sh $SCRIPTS_DIR/Forward_${solver}.sh $isource $NPROC_SPECFEM $data_tag $data_list \
        $velocity_dir $SAVE_FORWARD $WORKING_DIR $DATA_DIR $job $SUBMIT_DIR 2>./job_info/error_Forward_simulation
    

    # STEP two -- adjoint source
    STARTTIME=$(date +%s)

    sh $SCRIPTS_DIR/adjoint_source.sh $isource $NPROC_SPECFEM $compute_adjoint $data_list \
        $measurement_list $misfit_type_list $WORKING_DIR $Wscale $wavelet_path 2>./job_info/error_adj_source

  

    # STEP three -- adjoint simulation?
    STARTTIME=$(date +%s)

    if $compute_adjoint; then
        data_tag='SEM'
        SAVE_FORWARD=false
        sh $SCRIPTS_DIR/Adjoint_${solver}.sh $isource $NPROC_SPECFEM $data_tag \
            $velocity_dir $SAVE_FORWARD $WORKING_DIR 2>./job_info/error_Adjoint_simulation
    fi
