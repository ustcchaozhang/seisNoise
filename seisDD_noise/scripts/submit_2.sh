#!/bin/bash

source parameter

workflow_DIR="$package_path/workflow"




echo " create new job_info file ..."
rm -rf job_info
mkdir job_info

echo 
echo " create result file ..."
rm -rf RESULTS
mkdir -p RESULTS


workflow_DIR="$package_path/workflow"

echo " edit request nodes and tasks ..."
nproc=$NPROC_SPECFEM
nodes=$(echo $(echo "$NSRC $NPROC_SPECFEM  $max_nproc_per_node" | awk '{ print $1*$2/$3 }') | awk '{printf("%d\n",$0+=$0<0?0:0.999)}')
echo " Request $nodes nodes, $ntasks tasks, $nproc cpus per task "

echo
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
echo

echo "submit job"
echo
    echo "pbs system ..."

if [ $queue == 'sandy' ]; then
    echo "qsub -q $queue -l nodes=$nodes:ppn=$max_nproc_per_node  -l walltime=$WallTime -e job_info/error -o job_info/output  $Job_title.sh"
    qsub -q $queue  -l nodes=$nodes:ppn=$max_nproc_per_node  -l walltime=$WallTime -e job_info/error -o job_info/output  $Job_title.sh

elif [ $queue == 'debug' ]; then
    echo "qsub -l nodes=$nodes:ppn=$max_nproc_per_node  -l walltime=$WallTime -q $queue   -e job_info/error -o job_info/output  $Job_title.sh"
    qsub  -l nodes=$nodes:ppn=$max_nproc_per_node  -l walltime=$WallTime -q $queue  -e job_info/error -o job_info/output  $Job_title.sh

else
    qsub  -l nodes=$nodes:ppn=$max_nproc_per_node  -l walltime=$WallTime -e job_info/error -o job_info/output  $Job_title.sh

   
fi

echo
