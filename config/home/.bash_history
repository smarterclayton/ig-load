curl -i ${GW_IP}/v1/completions -H 'Content-Type: application/json' -d @/ig-load/scenario/body_prompt_100_base
cd /ig-load/scenario && ADDR=${GW_IP} ../bench 1,script_medium &
vegeta report /ig-load/scenario/output/*.bin
