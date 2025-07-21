mpirun --bind-to socket --host vllm-deepseek-r1-ep-0,vllm-deepseek-r1-ep-0-1
curl -i ${GW_IP}/v1/completions -H 'Content-Type: application/json' -d @/ig-load/scenario/body_prompt_100_base
cd /ig-load/scenario && ADDR=${GW_IP} ../bench 1,script_1k_base &
vegeta report /ig-load/scenario/output/*.bin
netstat -ptn | grep -i established
GW_IP=vllm-deepseek-r1-ep:8000
GW_IP=vllm-deepseek-r1-ep-cos:8000
