#!/bin/bash
PREV_TOTAL=(0 0 0 0 0)
PREV_IDLE=(0 0 0 0 0)

rm -f cpu_usage.txt

while true
do
    # Get the each CPU statistics
    CPU=($(adb shell cat /proc/stat | sed -n '1,5p'))
    echo "=========="

    # CPU0=(`adb shell cat /proc/stat | sed -n '2p'`)
    # CPU1=(`adb shell cat /proc/stat | sed -n '3p'`)
    # CPU2=(`adb shell cat /proc/stat | sed -n '4p'`)
    # CPU3=(`adb shell cat /proc/stat | sed -n '5p'`)
    CPU_TOTAL=(${CPU[@]:0:11})
    CPU0=(${CPU[@]:11:11})
    CPU1=(${CPU[@]:22:11})
    CPU2=(${CPU[@]:33:11})
    CPU3=(${CPU[@]:44:11})
    echo ${CPU_TOTAL[*]}
    echo ${CPU0[*]}
    echo ${CPU1[*]}
    echo ${CPU2[*]}
    echo ${CPU3[*]}
    # idle CPU time.
    let "IT=${CPU_TOTAL[4]}+${CPU_TOTAL[5]}"
    let "I0=${CPU0[4]}+${CPU0[5]}"
    let "I1=${CPU1[4]}+${CPU1[5]}"
    let "I2=${CPU2[4]}+${CPU2[5]}"
    let "I3=${CPU3[4]}+${CPU3[5]}"
    IDLE=("${IT}" "${I0}" "${I1}" "${I2}" "${I3}")
    # echo ${IDLE[*]}

    # Calculate the total CPU time.
    TOTAL=()
    TT=0
    T0=0
    T1=0
    T2=0
    T3=0

    for index in "${!CPU0[@]}"
    do
        let "TT=$TT+${CPU_TOTAL[$index]}"
        let "T0=$T0+${CPU0[$index]}"
        let "T1=$T1+${CPU1[$index]}"
        let "T2=$T2+${CPU2[$index]}"
        let "T3=$T3+${CPU3[$index]}"
    done

    TOTAL=($TT $T0 $T1 $T2 $T3)

    # echo ${TOTAL[*]}

    # Calculate the CPU usage since we last checked.
    DIFF_USAGE=()
    for index in "${!TOTAL[@]}"
    do
        let "DIFF_IDLE=${IDLE[$index]}-${PREV_IDLE[$index]}"
        let "DIFF_TOTAL=${TOTAL[$index]}-${PREV_TOTAL[$index]}"
        let "diffusage=100*($DIFF_TOTAL-$DIFF_IDLE)/$DIFF_TOTAL"
        DIFF_USAGE+=($diffusage)
        if [ $index == 0 ]
        then
            echo -e "\rCPU : $diffusage%  \b\b"
        else
            let "NUM = $index-1"
            echo -e "\rCPU$NUM: $diffusage%  \b\b"
        fi

    done
    echo ${DIFF_USAGE[@]} >> cpu_usage.txt
    # Remember the total and idle CPU times for the next check.
    PREV_TOTAL=("${TOTAL[@]}")
    PREV_IDLE=("${IDLE[@]}")

    # Wait before checking again.
    sleep 1
done
