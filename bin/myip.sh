#!/bin/bash

# works only without spaces in array elements (IFS)
arr_join() {
    local IFS="$1"; shift; echo "$*"
}

lookup_opendns() {
    if [[ -x "$(which dig)" ]]; then
        result="$(dig +short +time=2 myip.opendns.com @resolver1.opendns.com)"
        if [[ $? -eq 0 && "${result}" != "" ]]; then
            echo '{"type":"dig_myip.opendns.com","value":"'"${result}"'"}'
        fi
    fi
}

lookup_akamai() {
    if [[ -x "$(which curl)" ]]; then
        result="$(curl --fail --silent --max-time 3 http://whatismyip.akamai.com/)"
        if [[ $? -eq 0 && "${result}" != "" ]]; then
            echo '{"type":"curl_whatismyip.akamai.com","value":"'"${result}"'"}'
        fi
    fi
}

exec 2>/dev/null

declare -a results

opendns="$(lookup_opendns)"
if [[ "${opendns}" != "" ]]; then
    results+=("${opendns}")
fi

akamai="$(lookup_akamai)"
if [[ "${akamai}" != "" ]]; then
    results+=("${akamai}")
fi

echo "[$(arr_join , ${results[@]})]"
