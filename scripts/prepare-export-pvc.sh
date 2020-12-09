#!/bin/bash
echo "Export and clean the persistent volume claims."
PVS=($(kubectl --kubeconfig .tmp/old_kubeconfig.yaml get pvc -o json | jq -r '.items[].metadata.name'))
NUM=`echo $PVS | wc -l`
for ((i=0;i<$NUM;i++)); do
    PVC_NAME=${PVS[i]}
    echo "Fetching pvc ${PVC_NAME}"
    kubectl --kubeconfig .tmp/old_kubeconfig.yaml get pvc ${PVC_NAME} -o yaml > "./.tmp/to-clean/pvc_${PVC_NAME}"
done
