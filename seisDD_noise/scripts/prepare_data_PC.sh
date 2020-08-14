#!/bin/bash

velocity_dir=$1
SUBMIT_DIR=$2
SCRIPTS_DIR=$3
SUBMIT_RESULT=$4
WORKING_DIR=$5

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
            #temp_prepare="./job_info/pre_sour_"${isource}

            cd $SUBMIT_DIR

            data_tag='DATA_obs'
            SAVE_FORWARD=false

            if  $ExistDATA && [ -d "$DATA_DIR" ]; then    
                echo "ExistDATA=true"
                echo "sh $SCRIPTS_DIR/copy_data.sh $isource $data_tag $data_list $WORKING_DIR $DATA_DIR $SUBMIT_DIR"
                sh $SCRIPTS_DIR/copy_data.sh $isource $data_tag $data_list $WORKING_DIR $DATA_DIR $SUBMIT_DIR 2>./job_info/error_copy_data
            else
                echo "ExistDATA=false"
                echo "sh $SCRIPTS_DIR/Forward_${solver}.sh $isource $NPROC_SPECFEM $data_tag $data_list \
                $velocity_dir $SAVE_FORWARD $WORKING_DIR $DATA_DIR $job $SUBMIT_DIR"
                sh $SCRIPTS_DIR/Forward_${solver}.sh $isource $NPROC_SPECFEM $data_tag $data_list \
                $velocity_dir $SAVE_FORWARD $WORKING_DIR $DATA_DIR $job $SUBMIT_DIR 2>./job_info/error_Forward_simulation
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
    #temp_prepare="./job_info/pre_sour_"${isource}

    cd $SUBMIT_DIR
    
    data_tag='DATA_obs'
    SAVE_FORWARD=false
    
    if  $ExistDATA && [ -d "$DATA_DIR" ]; then
        echo "ExistDATA=true"
        echo "sh $SCRIPTS_DIR/copy_data.sh $isource $data_tag $data_list $WORKING_DIR $DATA_DIR $SUBMIT_DIR"
        sh $SCRIPTS_DIR/copy_data.sh $isource $data_tag $data_list $WORKING_DIR $DATA_DIR $SUBMIT_DIR 2>./job_info/error_copy_data
    else
        echo "ExistDATA=false"
        echo "sh $SCRIPTS_DIR/Forward_${solver}.sh $isource $NPROC_SPECFEM $data_tag $data_list \
        $velocity_dir $SAVE_FORWARD $WORKING_DIR $DATA_DIR $job $SUBMIT_DIR"
        sh $SCRIPTS_DIR/Forward_${solver}.sh $isource $NPROC_SPECFEM $data_tag $data_list \
        $velocity_dir $SAVE_FORWARD $WORKING_DIR $DATA_DIR $job $SUBMIT_DIR 2>./job_info/error_Forward_simulation
    fi
} & done
wait

ENDTIME=$(date +%s)
Ttaken=$(($ENDTIME - $STARTTIME))
echo "Data preparation took $Ttaken seconds"
