curl -X POST --header "Accept: application/json" "http://localhost:8001/api/workflows/v1/batch" \
	-F workflowSource=@variantrecalSNP_INDEL.wdl \
	-F workflowInputs=@variantrecalSNP_INDEL.json \
	-F workflowOptions=@cromwell-mysql/cromwell/workflow-options/workflowoptions.json
