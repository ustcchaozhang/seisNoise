#!/bin/bash

#this is the 2nd step for seiNoise:submit the project according to your system :pbs or slurm or PC/workstation"
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
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



if [ $system == 'slurm' ]; then
    echo "copy the pbsssh profile for pbs system"
    sbatch -p $queue -N $nodes -n $ntasks --cpus-per-task=$nproc -t $WallTime -e job_info/error -o job_info/output $Job_title.sh
elif [ $system == 'pbs' ]; then
    echo "copy the pbsssh profile for pbs system"
    cp $SCRIPTS_DIR/pbsssh.sh   ./
    echo "pbs system submitted"
    qsub  -l nodes=$nodes:ppn=$max_nproc_per_node  -l walltime=$WallTime -e job_info/error -o job_info/output  $Job_title.sh    
else
    echo "PC or workstation system submitted"
    sh $Job_title.sh
fi
