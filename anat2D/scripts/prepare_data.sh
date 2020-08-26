#!/bin/bash

velocity_dir=$1
SUBMIT_DIR=$2
SCRIPTS_DIR=$3
SUBMIT_RESULT=$4
WORKING_DIR=$5

source $SUBMIT_DIR/parameter

cd $SUBMIT_DIR

#isource=$(($PBS_VNODENUM))
iproc=$SLURM_PROCID
iproc0=1
if [ $iproc -lt $NSRC ] && [ $iproc -ge 0 ]; then
    isource=$(echo $(echo "$iproc $iproc0" | awk '{print $1+$2}'))
    echo "isource="$isource
    echo "REZVANOLLAH"

    cd $SUBMIT_DIR
	data_tag='DATA_obs'
	SAVE_FORWARD=false

  STARTTIME=$(date +%s)
  if  $ExistDATA && [ -d "$DATA_DIR" ]; then    
      echo "ExistDATA=true"
      echo "sh $SCRIPTS_DIR/copy_data.sh $isource $data_tag $data_list $WORKING_DIR $DATA_DIR $SUBMIT_DIR"
      sh $SCRIPTS_DIR/copy_data.sh $isource $data_tag $data_list $WORKING_DIR $DATA_DIR $SUBMIT_DIR 2>./job_info/error_copy_data

  else
      echo "ExistDATA=false"
       $SCRIPTS_DIR/Forward_${solver}.sh $isource $NPROC_SPECFEM $data_tag $data_list \
       $velocity_dir $SAVE_FORWARD $WORKING_DIR $DATA_DIR $job $SUBMIT_DIR  2>./job_info/error_Forward_simulation
  fi
fi

     ENDTIME=$(date +%s)
     Ttaken=$(($ENDTIME - $STARTTIME))
     echo "Data preparation took $Ttaken seconds"

