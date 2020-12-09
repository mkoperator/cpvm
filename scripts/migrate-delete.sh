#!/bin/bash
echo "Deleting volume claims from old cluster."
PVCS=($(ls .tmp/migrated/ | grep pvc_))
NUMPVC=`echo $PVCS | wc -l`
for ((i=0;i<$NUMPVC;i++)); do
    PVC_NAME=${PVCS[i]}
    echo "Removing pvc ${PVC_NAME}"
    kubectl --kubeconfig .tmp/old_kubeconfig.yaml delete -f ".tmp/migrated/${PVC_NAME}"
done
