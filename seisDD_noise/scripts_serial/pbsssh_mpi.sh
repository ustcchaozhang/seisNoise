#!/bin/bash 

# temporary work around for pbsdsh

#cat ${PBS_NODEFILE}

k=0;
iproc=0;
iproc1=0;

npro=4;

#echo $PBS_NODEFILE
cat  $PBS_NODEFILE

for i in `cat $PBS_NODEFILE`;
do	

        #ntask_ceiling=$(echo $(echo "$time $j $npro" | awk '{print ($time+$2)%$3}')  )
        iproc=$(($iproc + 1));
        if [ $iproc -gt 11 ]; then
        break
        fi

        ntask_ceiling=$(echo $(echo "$iproc $iproc1  $npro" | awk '{print ($1+$2)%$3}'))
        ntask=$(echo $(echo "$iproc $iproc1 $npro" | awk '{print ($1+$2)/$3}') | awk '{printf("%d\n",$0+=$0<0?0:0.999)}')
        echo "iproc="$iproc"npro="$npro"ntask_ceiling"$ntask_ceiling"ntask"$ntask

        if [ $ntask_ceiling -eq 1 ] ; then 
       	   ntask=$(($ntask - 1));
           ssh $i "export PBS_VNODENUM=$ntask; $@" & 
           echo "ntask_ceiling="$ntask_ceiling"i="$i"export PBS_VNODENUM="$ntask         
           if [ $ntask -gt 2 ]; then
              break
           fi
        else
           continue
        fi 

        #iproc=$(($iproc + 1));
	#k=$(($k + 1));


#       echo "k=",$k
        if [ $k -gt 11 ]; then
        break
        fi 




done

wait

