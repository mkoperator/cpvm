#!/bin/bash
echo "Checking for sed."
if ! command -v sed &> /dev/null
then
    echo "sed could not be found."
    exit
fi