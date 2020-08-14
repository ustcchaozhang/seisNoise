#!/bin/bash

velocity_dir=$1
compute_adjoint=$2
SUBMIT_DIR=$3
SCRIPTS_DIR=$4
SUBMIT_RESULT=$5
WORKING_DIR=$6

source $SUBMIT_DIR/parameter

TTR=$(($NSRC/$SOT))
LTR=$(($NSRC%$SOT))
STARTTIME=$(date +%s)

if [ $TTR -gt 0 ]
then {
    for((i=1;i<=$TTR;i++))
    do {
        for((j=1;j<=$SOT;j++))
        do { 
            isource=$((($i-1)*$SOT+$j))
            echo "isource=",$isource

            cd $SUBMIT_DIR
            data_tag='DATA_syn'

            if $compute_adjoint ; then   
                SAVE_FORWARD=true
            else
                SAVE_FORWARD=false
            fi

            echo "sh $SCRIPTS_DIR/Forward_${solver}.sh $isource $NPROC_SPECFEM $data_tag $data_list \
            $velocity_dir $SAVE_FORWARD $WORKING_DIR $DATA_DIR $job $SUBMIT_DIR"
            sh $SCRIPTS_DIR/Forward_${solver}.sh $isource $NPROC_SPECFEM $data_tag $data_list \
            $velocity_dir $SAVE_FORWARD $WORKING_DIR $DATA_DIR $job $SUBMIT_DIR 2>./job_info/error_Forward_simulation

            echo "sh $SCRIPTS_DIR/adjoint_source.sh $isource $NPROC_SPECFEM $compute_adjoint $data_list \
            $measurement_list $misfit_type_list $WORKING_DIR $Wscale $wavelet_path"    
            sh $SCRIPTS_DIR/adjoint_source.sh $isource $NPROC_SPECFEM $compute_adjoint $data_list \
            $measurement_list $misfit_type_list $WORKING_DIR $Wscale $wavelet_path 2>./job_info/error_adj_source

            if $compute_adjoint; then
                data_tag='SEM'
                SAVE_FORWARD=false
                echo "sh $SCRIPTS_DIR/Adjoint_${solver}.sh $isource $NPROC_SPECFEM $data_tag \
                $velocity_dir $SAVE_FORWARD $WORKING_DIR"
                sh $SCRIPTS_DIR/Adjoint_${solver}.sh $isource $NPROC_SPECFEM $data_tag \
                $velocity_dir $SAVE_FORWARD $WORKING_DIR 2>./job_info/error_Adjoint_simulation
            fi
        } & done
        wait
    }
    done
}
fi

for((j=1;j<=$LTR;j++))
do {
    isource=$(($TTR*$SOT+$j))
    echo "isource=",$isource

    cd $SUBMIT_DIR
    data_tag='DATA_syn'

    if $compute_adjoint ; then
        SAVE_FORWARD=true
    else
        SAVE_FORWARD=false
    fi

    echo "sh $SCRIPTS_DIR/Forward_${solver}.sh $isource $NPROC_SPECFEM $data_tag $data_list \
    $velocity_dir $SAVE_FORWARD $WORKING_DIR $DATA_DIR $job $SUBMIT_DIR"
    sh $SCRIPTS_DIR/Forward_${solver}.sh $isource $NPROC_SPECFEM $data_tag $data_list \
    $velocity_dir $SAVE_FORWARD $WORKING_DIR $DATA_DIR $job $SUBMIT_DIR 2>./job_info/error_Forward_simulation

    echo "sh $SCRIPTS_DIR/adjoint_source.sh $isource $NPROC_SPECFEM $compute_adjoint $data_list \
    $measurement_list $misfit_type_list $WORKING_DIR $Wscale $wavelet_path"    
    sh $SCRIPTS_DIR/adjoint_source.sh $isource $NPROC_SPECFEM $compute_adjoint $data_list \
    $measurement_list $misfit_type_list $WORKING_DIR $Wscale $wavelet_path 2>./job_info/error_adj_source

    if $compute_adjoint; then
        data_tag='SEM'
        SAVE_FORWARD=false
        echo "sh $SCRIPTS_DIR/Adjoint_${solver}.sh $isource $NPROC_SPECFEM $data_tag \
        $velocity_dir $SAVE_FORWARD $WORKING_DIR"
        sh $SCRIPTS_DIR/Adjoint_${solver}.sh $isource $NPROC_SPECFEM $data_tag \
        $velocity_dir $SAVE_FORWARD $WORKING_DIR 2>./job_info/error_Adjoint_simulation
    fi
} & done
wait

ENDTIME=$(date +%s)
Ttaken=$(($ENDTIME - $STARTTIME))
echo "Adjoint simulation took $Ttaken seconds"
