#!/bin/bash
echo "Export and clean the persistent volumes."
PVS=($(kubectl --kubeconfig .tmp/old_kubeconfig.yaml get pv -o json | jq -r '.items[].metadata.name'))  #
NUM=`echo $PVS | wc -l`
for ((i=0;i<$NUM;i++)); do
    PV_NAME=${PVS[i]}
    echo "Fetching pv ${PV_NAME}" 
    kubectl --kubeconfig .tmp/old_kubeconfig.yaml get pv ${PV_NAME} -o yaml > "./.tmp/to-clean/pv_${PV_NAME}"
done
