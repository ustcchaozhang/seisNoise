#!/bin/bash

source parameter

workflow_DIR="$package_path/workflow"

if [ "$job" ==  "modeling" ] || [ "$job" ==  "Modeling" ]
then
    echo " ########################################################"
    echo " Forward modeling .." 
    echo " ########################################################"
    cp $workflow_DIR/Modeling.sh $Job_title.sh

elif [ "$job" ==  "kernel" ] || [ "$job" ==  "Kernel" ]
then
    echo " ########################################################"
    echo " Adjoint Inversion .." 
    echo " ########################################################"
    cp $workflow_DIR/Kernel.sh $Job_title.sh

elif [ "$job" ==  "inversion" ] || [ "$job" ==  "FWI" ]
then
    echo " ########################################################"
    echo " Adjoint Inversion .." 
    echo " ########################################################"
    cp $workflow_DIR/AdjointInversion.sh $Job_title.sh
else
    echo "Wrong job: $job"
fi



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
nodes=$(echo $(echo "$NSRC $max_nproc_per_node" | awk '{ print $1/$2 }') | awk '{printf("%d\n",$0+=$0<0?0:0.999)}')
echo " Request $nodes nodes, $ntasks tasks, $nproc cpus per task "

echo
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
echo

echo "submit job"
echo
if [ $system == 'slurm' ]; then
    echo "slurm system ..."
    echo "sbatch -p $queue -N $nodes -n $ntasks --cpus-per-task=$nproc -t $WallTime -e job_info/error -o job_info/output $Job_title.sh"
    sbatch -p $queue -N $nodes -n $ntasks --cpus-per-task=$nproc -t $WallTime -e job_info/error -o job_info/output $Job_title.sh

elif [ $system == 'pbs' ]; then
    echo "pbs system ..."
    echo "qsub -l nodes=$nodes:ppn=$max_nproc_per_node  -l walltime=$WallTime -e job_info/error -o job_info/output  $Job_title.sh"
    qsub -l nodes=$nodes:ppn=$max_nproc_per_node  -l walltime=$WallTime -e job_info/error -o job_info/output  $Job_title.sh
    #qsub -l nodes=$nodes:ppn=1  -l walltime=$WallTime -e job_info/error -o job_info/output  $Job_title.sh

fi
echo
