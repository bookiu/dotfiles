for item in $(kubectl config get-contexts | awk '{print $(NF-2)}' | tail -n +2); do
    alias kubectl.$item="kubectl --context=$item"
    alias k.$item="kubectl --context=$item"
done
