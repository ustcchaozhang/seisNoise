#!/bin/bash

#!/bin/bash

echo 
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
echo
echo " source parameter file ..." 
source parameter

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

echo 
read -p "Do you wish to comiple lib codes (y/n)?" yn
if [ $yn == 'y' ]; then 
cd /scratch/l/liuqy/zhang18/seisDD/seisDD/lib
make -f make_lib clean
make  -f make_lib
cd -
fi


echo
echo " renew parameter file ..."
cp $package_path/SRC/seismo_parameters.f90 ./bin/
cp $package_path/scripts/renew_parameter.sh ./
./renew_parameter.sh


echo 
echo " complile source codes ... "

#cp $package_path/lib/make_lib  ./
#make -f make_lib clean
#make -f make_lib


rm -rf *.mod make_file
cp $package_path/make/make_$compiler ./make_file
cp $package_path/lib/constants.mod ./
FILE="make_file"
sed -e "s#^SRC_DIR=.*#SRC_DIR=$package_path/SRC#g"  $FILE > temp;  mv temp $FILE
make -f make_file clean
make -f make_file

echo "the prepared work is done"
