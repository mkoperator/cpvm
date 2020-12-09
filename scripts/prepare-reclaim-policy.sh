#!/bin/bash
echo "Updating PVC reclaim policy."
PVS=($(kubectl --kubeconfig .tmp/old_kubeconfig.yaml get pv -o json | jq -r '.items[].metadata.name'))  #
NUM=`echo $PVS | wc -l`
for ((i=0;i<$NUM;i++)); do
    PV_NAME=${PVS[i]}
    echo "Updating reclaim policy on ${PV_NAME}" 
    kubectl --kubeconfig .tmp/old_kubeconfig.yaml patch pv ${PV_NAME} -p '{"spec":{"persistentVolumeReclaimPolicy":"Retain"}}'
done
