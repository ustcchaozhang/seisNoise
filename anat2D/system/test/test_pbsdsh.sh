#!/bin/bash

module list
SUBMIT_DIR=$1
# parameters
source $SUBMIT_DIR/parameter

# local id (from 0 to $ntasks-1)
iproc=$PBS_VNODENUM

echo "test pbsdsh iproc=$iproc"

# run serial exe 
#$SUBMIT_DIR/test/hello.exe

# run mpi exe 
mpirun -np $NPROC $SUBMIT_DIR/test/hello_mpi.exe
