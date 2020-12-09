#!/bin/bash
echo "Creating the volume claims on new cluster."
PVCS=($(ls .tmp/to-migrate/ | grep pvc_))
NUMPVC=`echo $PVCS | wc -l`
for ((i=0;i<$NUMPVC;i++)); do
    PVC_NAME=${PVCS[i]}
    echo "Creating pvc ${PVC_NAME}"
    kubectl --kubeconfig .tmp/new_kubeconfig.yaml apply -f ".tmp/to-migrate/${PVC_NAME}"
    mv ".tmp/to-migrate/${PVC_NAME}" ".tmp/migrated/${PVC_NAME}"
done
