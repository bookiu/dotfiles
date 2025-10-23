#!/bin/bash

kinit_login() {
    if [ -z "$KERBEROS_USER" -o -z "$KERBEROS_PASS" ]; then
        echo "\$KERBEROS_USER or \$KERBEROS_PASS environment variables are not defined!"
        return 1
    fi
    local cmd_line=$(cat <<EOF
spawn kinit $KERBEROS_USER
expect {
    "*assword*"  {
        send "$KERBEROS_PASS\\n"
    }
}
interact
EOF
    )

    expect -c "$cmd_line"
}

alias klogin=kinit_login
