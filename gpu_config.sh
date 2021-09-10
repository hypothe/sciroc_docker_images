#!/bin/bash

COMP=75

dd_make=`find -wholename "*darknet/Makefile"`
dros_cmake=`find -wholename "*darknet_ros/CMakeLists.txt"`

FLAGS="GPU CUDNN OPENCV"

for f in ${FLAGS}
do
	awk -v flag_m="${f}=0" -v flag_s="${f}=1" '{sub(flag_m, flag_s); print $0}' $dd_make > .tmp && mv .tmp $dd_make
done

for f in  ${dd_make} ${dros_cmake}
do
	sed -i "/-gencode arch=compute_35,code=sm_35/i -gencode arch=compute_${COMP},code=compute_${COMP} \\" $f
done