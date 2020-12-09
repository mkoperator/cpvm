#!/bin/bash
echo "Creating the volumes on new cluster."
PVS=($(ls .tmp/to-migrate/ | grep pv_))
NUMPV=`echo $PVS | wc -l`
for ((i=0;i<$NUMPV;i++)); do
    PV_NAME=${PVS[i]}
    echo "Creating pvc ${PV_NAME}"
    kubectl --kubeconfig .tmp/new_kubeconfig.yaml apply -f ".tmp/to-migrate/${PV_NAME}"
    PV_TRUNCATED=$(echo "${PV_NAME}" | sed 's/^.\{3\}//g')
    PVC_NAME=$(kubectl --kubeconfig .tmp/new_kubeconfig.yaml get pv ${PV_TRUNCATED})
    PVC_UID=$(kubectl --kubeconfig .tmp/new_kubeconfig.yaml get pvc/${PVC_NAME} -o jsonpath='{.metadata.uid}')
    kubectl --kubeconfig .tmp/new_kubeconfig.yaml patch pv ${PV_TRUNCATED} -p "{\"spec\":{\"claimRef\":{\"uid\":\"${PVC_UID}\"}}}"
    mv ".tmp/to-migrate/${PV_NAME}" ".tmp/migrated/${PV_NAME}"
done