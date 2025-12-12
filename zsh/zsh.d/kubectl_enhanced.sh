_parse_node_pyscript=$(cat <<EOF
import sys
import re
import json


match_pattern = re.compile(r'Capacity:[\s\S]+?cpu:\s+(.*)[\s\S]+?memory:\s+(.*)[\s\S]+?Allocatable:[\s\S]+?cpu:\s+(.*)[\s\S]+?memory:\s+(.*)[\s\S]+?Allocated resources:[\s\S]+?cpu\s+(\d+m?)\s\(\d+%\)\s+(\d+m?)\s\(\d+%\)[\s\S]+?memory\s+(\d+(Mi|Gi|Ki))\s\(\d+%\)\s+(\d+(Mi|Gi|Ki))\s\(\d+%\)')

def extract_node_resources(kubectl_output):
    matched = match_pattern.search(kubectl_output)
    if not matched:
        return None

    capacity_cpu = matched.group(1)
    capacity_memory = matched.group(2)
    allocatable_cpu = matched.group(3)
    allocatable_memory = matched.group(4)
    allocated_requests_cpu = matched.group(5)
    allocated_requests_memory = matched.group(7)
    allocated_limits_cpu = matched.group(6)
    allocated_limits_memory = matched.group(9)

    raw = {
        "capacity_cpu": capacity_cpu,
        "capacity_memory": capacity_memory,
        "allocatable_cpu": allocatable_cpu,
        "allocatable_memory": allocatable_memory,
        "allocated_requests_cpu": allocated_requests_cpu,
        "allocated_requests_memory": allocated_requests_memory,
        "allocated_limits_cpu": allocated_limits_cpu,
        "allocated_limits_memory": allocated_limits_memory
    }
    ret = {}
    for k, v in raw.items():
        if k.endswith("cpu"):
            if v.endswith("m"):
                val = round(int(v[:-1]) / 1000, 2)
            elif v.endswith("n"):
                val = round(int(v[:-1]) / 1000000000, 2)
            else:
                val = int(v)
            ret[k] = val
        elif k.endswith("memory"):
            if v.endswith("Ki"):
                val = round(int(v[:-2]) / 1024 / 1024, 2)
            elif v.endswith("Mi"):
                val = round(int(v[:-2]) / 1024, 2)
            elif v.endswith("Gi"):
                val = int(v[:-2])
            elif v.endswith("m"):
                val = round(int(v[:-1]) / 1000 / 1024 / 1024 / 1024, 2)
            else:
                val = int(v)
            ret[k] = val

    return ret

# Usage example (assuming the kubectl output is stored in a variable named kubectl_output)
result = extract_node_resources(sys.stdin.read())
print(json.dumps(result, ensure_ascii=False))
EOF
)

kctl() {
    kubectx=""
    # find kubectl context from environment variables
    # KUBECTX, KUBE_CTX, KUBECONTEXT, KUBE_CONTEXT、
    local envkeys=("KUBECTX" "KUBE_CTX" "KUBECONTEXT" "KUBE_CONTEXT")
    for k in "${envkeys[@]}"; do
        kubectx=$(printenv $k)
        if [ -n "$kubectx" ]; then
            break
        fi
    done
    if [ -n "$kubectx" ]; then
        kubectl --context=$kubectx "$@"
    else
        kubectl "$@"
    fi
}

kgnp() {
    if [ $# -eq 0 ]; then
        echo "Usage: kgnp <node_name>"
        return 1
    fi
    printf "%-16s %-14s %-63s %-5s %-12s %-8s %s\n" "Node" "NAMESPACE" "NAME" "READY" "STATUS" "RESTARTS" "AGE"
    for node in $@; do
        pods=$(kctl get pods -A --field-selector=spec.nodeName=$node | head -n +2)
        if [ $? -ne 0 ]; then
            continue
        fi
        kctl get pods -A --field-selector=spec.nodeName=$node | tail -n +2 | \
            awk -v node=$node '{printf "%-16s %-14s %-63s %-5s %-12s %-8s %s\n", node, $1, $2, $3, $4, $5, $6}'
    done
}


kgn() {
    nodes_info=$(kctl get nodes --show-labels $* | tail -n +2)
    printf "%-22s %-24s %-12s %-15s %-20s %-21s %-s\n" "Node" "Status" "NodeLevel" "Zone" "InstanceType" "MachinePool" "Labels"
    echo "$nodes_info" | while IFS= read -r line; do
        # 在这里处理每一行
        n=$(echo "$line" | awk '{print $1}')
        local _status=$(echo "$line" | awk '{print $2}')
        local labels=$(echo "$line" | awk '{print $6}')
        local node_level="-"
        local zone="-"
        local instance_type="-"
        local machine_pool="-"
        local -a wanna_labels=()

        # Zsh compatible way to split by comma
        for label in ${(s/,/)labels}; do
            if [[ "$label" == "topology.kubernetes.io/zone"* ]]; then
                zone=$(echo "$label" | awk -F'=' '{print $2}')
                continue
            fi
            if [[ "$label" == "node.kubernetes.io/instance-type"* ]]; then
                instance_type=$(echo "$label" | awk -F'=' '{print $2}')
                continue
            fi
            if [[ "$label" == "cluster.vke.volcengine.com/machinepool-name"* ]]; then
                machine_pool=$(echo "$label" | awk -F'=' '{print $2}')
                continue
            fi
            if [[ "$label" == *"kubernetes.io"* ]]; then
                continue
            fi
            if [[ "$label" == "nodeLevel"* ]]; then
                node_level=$(echo "$label" | awk -F'=' '{print $2}')
                continue
            fi
            # wanna_labels+=("$label")
        done
        # join wanna_labels by comma
        local lb=$(IFS=,; echo "${wanna_labels[*]}")
        printf "%-22s %-24s %-12s %-15s %-20s %-21s %-s\n" "${n}" "${_status}" "${node_level}" "${zone}" "${instance_type}" "${machine_pool}" "${lb}"
    done
}


kgnd() {
    printf "%-15s %-15s %-15s %-15s %-19s %-19s %s\n" "Node" "Capacity" "Allocatable" "Remain" "Allocated(Requests)" "Allocated(Limits)" "Usage"
    for n in $*; do
        local node_info=$(kctl describe node $n 2> /dev/null)
        if [[ -z "$node_info" ]]; then
            continue
        fi
        local node_resources=$(echo "$node_info" | python3 -c "$_parse_node_pyscript")
        capacity_cpu=$(echo "$node_resources" | jq '.capacity_cpu')
        capacity_memory=$(echo "$node_resources" | jq '.capacity_memory')
        allocatable_cpu=$(echo "$node_resources" | jq '.allocatable_cpu')
        allocatable_memory=$(echo "$node_resources" | jq '.allocatable_memory')
        allocated_requests_cpu=$(echo "$node_resources" | jq '.allocated_requests_cpu')
        allocated_requests_memory=$(echo "$node_resources" | jq '.allocated_requests_memory')
        allocated_limits_cpu=$(echo "$node_resources" | jq '.allocated_limits_cpu')
        allocated_limits_memory=$(echo "$node_resources" | jq '.allocated_limits_memory')

        remain_cpu=$(echo "$allocatable_cpu - $allocated_requests_cpu" | bc)
        remain_memory=$(echo "$allocatable_memory - $allocated_requests_memory" | bc)

        usage_cpu=$(echo "scale=2; $allocated_requests_cpu / $allocatable_cpu * 100" | bc)
        usage_memory=$(echo "scale=2; $allocated_requests_memory / $allocatable_memory * 100" | bc)
        usage=$(printf "%d%%/%d%%" "$usage_cpu" "$usage_memory")

        capacity="${capacity_cpu}C/${capacity_memory}G"
        allocatable="${allocatable_cpu}C/${allocatable_memory}G"
        allocated_requests="${allocated_requests_cpu}C/${allocated_requests_memory}G"
        allocated_limits="${allocated_limits_cpu}C/${allocated_limits_memory}G"
        remain="${remain_cpu}C/${remain_memory}G"

        printf "%-15s %-15s %-15s %-15s %-19s %-19s %s\n" "${n}" "${capacity}" "${allocatable}" "${remain}" "${allocated_requests}" "${allocated_limits}" "${usage}"
    done
}

kenter() {
    echo "Entering Pod: kubectl exec -it $* -- sh -c 'clear; (bash || ash || sh)'"
    kctl exec -it $* -- sh -c 'clear; (bash || ash || sh)'
}

alias kexec="kctl exec -it"
alias kedit="kctl edit"
alias kgp="kctl get pods"
for ctx in $(kubectl config get-contexts -o name); do
    alias "kubectl.${ctx}"="kubectl --context=$ctx"
    alias "k.$ctx"="kubectl --context=$ctx"
    cmds=("kgnp" "kgn" "kgnd" "kexec" "kenter" "kedit" "kgp")
    for cmd in "${cmds[@]}"; do
        alias "${cmd}.${ctx}"="KUBECTX=$ctx ${cmd}"
    done
done
unset cmds ctx cmd
