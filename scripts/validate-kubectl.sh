#!/bin/bash
echo "Checking for kubectl."
if ! command -v kubectl &> /dev/null
then
    echo "kubectl could not be found."
    exit
fi