#!/bin/bash
module load intel intelmpi
ulimit -s unlimited
system='pbs'
# Submit directory
if [ $system == 'slurm' ]; then
    export SUBMIT_DIR=$SLURM_SUBMIT_DIR
elif [ $system == 'pbs' ]; then
    export SUBMIT_DIR=$PBS_O_WORKDIR
fi
cd $SUBMIT_DIR
source parameter

# Submit directory
if [ $system == 'slurm' ]; then
    echo "$SLURM_JOB_NODELIST"  >  ./job_info/NodeList
    echo "$SLURM_JOBID"  >  ./job_info/JobID
elif [ $system == 'pbs' ]; then
    echo "$PBS_NODEFILE"  >  ./job_info/NodeList
    echo "$PBS_JOBID"  >  ./job_info/JobID
fi

echo
echo "       This is to check your system: $system "
echo "**********************************************************"
echo

STARTTIME=$(date +%s)
echo "start time is :  $(date +"%T")"
echo

# Distribute tasks in serial or parallel on specified hosts
if [ $system == 'slurm' ]; then
    # request $NPROC CPUs for $ntasks tasks 
    # multiple CPUs for the multithreaded tasks
    # srun - distribute task to nodes under sbatch
    #srun -n $ntasks -c $NPROC -l -W 0  test/hello.sh 2>./job_info/error_run
    srun -l -W 0  test/test_srun.sh 2>./job_info/error_run 
elif [ $system == 'pbs' ]; then
    # pbsdsh - distribute task to nodes under pbs
    pbsdsh -v $SUBMIT_DIR/test/test_mpi.sh $SUBMIT_DIR 2>./job_info/error_run
fi
echo 
echo "test mpirun ..."
mpirun -np $NPROC $SUBMIT_DIR/test/test_mpi.sh $SUBMIT_DIR 2>./job_info/error_mpi 

ENDTIME=$(date +%s)
Ttaken=$(($ENDTIME - $STARTTIME))
echo
echo "finish time is : $(date +"%T")" 
echo "RUNTIME is :  $(($Ttaken / 3600)) hours ::  $(($(($Ttaken%3600))/60)) minutes  :: $(($Ttaken % 60)) seconds."

echo
echo "******************well done*******************************"
