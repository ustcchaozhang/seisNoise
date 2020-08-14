#!/bin/bash 

# temporary work around for pbsdsh

#cat ${PBS_NODEFILE}

k=0;
time=0;
npro=4;
j=1;

echo "PBS_NODEFILE=" $PBS_NODEFILE

basenodefile= $PBS_NODEFILE
echo "basenodefile=",$basenodefile


for i in `cat $PBS_NODEFILE`;
do	
        echo "time=",$time 
        echo "j=",$j
        echo "i=",$i

        ntask_ceiling=$(echo $(echo "$time $j $npro" | awk '{print ($time+$2)%$3}')  )         
        ntask=$(echo $(echo "$time $j $npro" | awk '{print ($time+$2)/$3}') | awk '{printf("%d\n",$0+=$0<0?0:0.999)}')         
        echo "ntask_ceiling=", $ntask_ceiling
        echo "ntask=", $ntask
        
#	echo $i >> $basenodefile.$ntask

        if [ $ntask_ceiling -eq 0 ] ; then
           ssh $i "export PBS_VNODENUM=$k; export PBS_NODEFILE=$basenodefile.$ntask; $@" &
           k=$(($k + 1));
           echo "k=",$k
        else 
           continue
        fi

        time=$(($time + 1));

        #echo "k=",$k
        #if [ $k -gt 0 ]; then
        #break
        #fi 


done

wait

