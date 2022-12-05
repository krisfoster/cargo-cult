#!/usr/bin/env bash

CS=$(oci iam compartment list --compartment-id-in-subtree true --all)
COMPARTMENT_NAME=$(echo $CS | jq '[.data[] | .name]' | gum filter | tr -d "\"" | tr -d ",")
echo $CS | jq -r --arg display_name ${COMPARTMENT_NAME} '.data | map(select(."name" == $display_name)) | .[0] | .id'
