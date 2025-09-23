mpirun --bind-to socket --host vllm-deepseek-r1-ep-0,vllm-deepseek-r1-ep-0-1
curl -i ${GW_IP}/v1/completions -H 'Content-Type: application/json' -d '{"temperature": 0,"prompt": "Write as if you were a critic: San Francisco","max_tokens": 100,"model": "base"}'
cd /ig-load/scenario && ADDR=${GW_IP} ../bench 1,script_1k_base &
vegeta report /ig-load/scenario/output/*.bin
netstat -ptn | grep -i established
GW_IP=vllm-deepseek-r1-ep:8000
GW_IP=vllm-deepseek-r1-ep-cos:8000

# sweep concurrency
for i in 1 2000 4000 5000 5500 6000 6500; do MAX_CONCURRENCY=$i DISAGG=1 bench_decode; sleep 5; done
# report a faulty node
gcloud compute instances report-host-as-faulty NODE '--fault-reasons=behavior=BEHAVIOR_UNSPECIFIED,description="machine reported mlx5_core device''s health compromised - reached miss count. Reported firmware Xid 149"' \
    --zone us-west2-c --async --disruption-schedule=IMMEDIATE &
# look for dmesg errors related to Xid or network
kubectl get pods -l app=vllm-deepseek-ep -o name | xargs -I {} kubectl exec -c vllm-worker {} -- /bin/bash -c 'dmesg | grep -E "reached miss count|Xid" | sed "s/^/$HOSTNAME: /"'
# run the internode test on all pods in parallel
kubectl get pods -o name -l component=vllm-deepseek-ep-decode | xargs -P0 -I {} kubectl exec -c vllm-worker {} -- /bin/bash -lc "test_internode"