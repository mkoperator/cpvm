#!/bin/bash
echo "Creating temp directory."
OLD=$1
NEW=$2
NAMESPACE=$3

rm -fR .tmp
# create our temp directory
cp -fR .temp-template .tmp

# sed replace namespace  in both kubefiles
sed -E "s/namespace: ([A-Za-z0-9-]+)/namespace: $NAMESPACE/g" $OLD > .tmp/old_kubeconfig.yaml
sed -E "s/namespace: ([A-Za-z0-9-]+)/namespace: $NAMESPACE/g" $NEW > .tmp/new_kubeconfig.yaml