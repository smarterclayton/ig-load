bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

shopt -s histappend
export HISTFILESIZE=1000000
export HISTSIZE=1000000
export HISTCONTROL=ignoreboth
shopt -s cmdhist

export GREP_COLORS='mt=1;32;40'

export PATH=${GOPATH}/bin:/root/bin:${PATH}

export OMPI_ALLOW_RUN_AS_ROOT=1
export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1

# Usage: profile_query <scenario_request> [<profile_duration>] [<initial_delay>]
function profile_query {
    curl -v -i ${GW_IP}/v1/completions -H 'Content-Type: application/json' -d "@/ig-load/scenario/${1:-body_prompt_100_deepseek}" & 
    sleep "${3:-1}"
    curl "${GW_IP}/start_profile" -X POST
    sleep "${2:-2}"
    curl "${GW_IP}/stop_profile" -X POST;
}
