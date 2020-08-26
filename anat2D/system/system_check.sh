#!/bin/bash
module load intel intelmpi
echo 
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
echo
echo " source parameter file ..." 
source parameter

echo 
echo " create new job_info file ..."
rm -rf job_info
mkdir job_info

echo 
echo " compile hello.f90"
rm -rf test/*.exe
${FC} test/hello.f90  -o test/hello.exe
${MPIFC} -DUSE_MPI -o test/hello_mpi.exe -g -O3 -xSSSE3 -no-ip -fno-fnalias -fno-alias -vec-report1 -assume byterecl -sox -cpp  -traceback -w -ftz test/hello_mpi.f90

echo 
echo " edit request nodes and tasks ..."
nproc=$NPROC
ntaskspernode=$(echo "$max_nproc_per_node $nproc" | awk '{ print $1/$2 }')
nodes=$(echo $(echo "$ntasks $nproc $max_nproc_per_node" | awk '{ print $1*$2/$3 }') | awk '{printf("%d\n",$0+=$0<0?0:0.999)}')
echo " Request $nodes nodes, $ntasks tasks, $ntaskspernode tasks per node, $nproc cpus per task "

echo
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
echo

echo "submit job ..."
echo
if [ $system == 'slurm' ]; then
    echo "slurm system ..."
    echo "sbatch -p $queue -N $nodes -n $ntasks -c $nproc -t $WallTime -e job_info/error -o job_info/output test/test_job.sh"
    sbatch -p $queue -N $nodes -n $ntasks -c $nproc -t $WallTime -e job_info/error -o job_info/output test/test_job.sh
elif [ $system == 'pbs' ]; then
    echo "pbs system ..."
    echo
    echo "qsub -q $queue -l nodes=$nodes:ppn=$max_nproc_per_node -l walltime=$WallTime -e job_info/error -o job_info/output  test/test_job.sh"
    qsub -q $queue -l nodes=$nodes:ppn=$max_nproc_per_node -l walltime=$WallTime -e job_info/error -o job_info/output -V test/test_job.sh
fi
echo
