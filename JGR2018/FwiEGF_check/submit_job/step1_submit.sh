#!/bin/bash

#!/bin/bash

echo ' this is the 1st step for seiNoise: compile the forward tool,lib code, source code '
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
echo
echo " source parameter file ..." 

source ./parameter

echo
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
echo
#rm -rf job_info
#mkdir job_info

echo 
echo " create result file ..."
#rm -rf RESULTS
#mkdir -p RESULTS

echo
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
echo
echo

workflow_DIR="$package_path/workflow"
echo 

var1="modeling"
var2="kernel"
var3="inversion"

if [ "${job,,}" == "${var1,,}"  ]
then
    echo " ########################################################"
    echo " Forward modeling ..." 
    echo " ########################################################"
    cp $workflow_DIR/Modeling.sh $Job_title.sh

elif [ "${job,,}" == "${var2,,}"  ]
then
    echo " ########################################################"
    echo " Kernel Construction ..." 
    echo " ########################################################"
    cp $workflow_DIR/Kernel.sh $Job_title.sh  
elif [ "${job,,}" == "${var3,,}"  ] || [ "${job,,}" == "${var4,,}"  ]
then
    echo " ########################################################"
    echo " Adjoint Inversion ..." 
    echo " ########################################################"
    cp $workflow_DIR/AdjointInversion.sh $Job_title.sh
fi


# Configure and compile specfem2D, this is just recommanded when your try to run seisNoise in the 1st time
read -p "Do you wish to Configure and compile specfem2D (y/n)?" yn
if [ $yn == 'y' ]; then 
echo "Configure and compile specfem2D ..."
cd $specfem_path
make clean
if [ $NPROC_SPECFEM == 1 ]; then
    ./configure FC=$compiler 
else
    ./configure FC=$compiler --with-mpi
fi
make all
cd -
fi

if [ ! -d "bin" ]; then
  cp -r $specfem_path/bin   ./
fi



# Configure and compile lib codes in $package_path/lib
echo 
read -p "Do you wish to comiple lib codes (y/n)?" yn
if [ $yn == 'y' ]; then 
cd $package_path/lib                 #
make -f make_lib clean
make  -f make_lib
cd -
fi


echo
echo " renew parameter file ..."
cp $package_path/SRC/seismo_parameters.f90 ./bin/
cp $package_path/scripts/renew_parameter.sh ./
./renew_parameter.sh

# Configure and compile source codes in $package_path/SRC
echo 
echo " complile source codes ... "
rm -rf *.mod make_file
cp $package_path/make/make_$compiler ./make_file
cp $package_path/lib/constants.mod ./
FILE="make_file"
sed -e "s#^SRC_DIR=.*#SRC_DIR=$package_path/SRC#g"  $FILE > temp;  mv temp $FILE
make -f make_file clean
make -f make_file


echo "the Configure and compile work is done"
