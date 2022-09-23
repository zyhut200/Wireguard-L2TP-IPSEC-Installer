#!/usr/bin/env bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $DIR/env.sh

if [[ ! -e $CHAPSECRETS ]] || [[ ! -r $CHAPSECRETS ]] || [[ ! -w $CHAPSECRETS ]]; then
    echo "$CHAPSECRETS is not exist or not accessible (are you root?)"
    exit 1
fi

if [[ $# -gt 0 ]]; then
    LOGIN="$1"
fi

while [[ -z "$LOGIN" ]];
do
    read -p "Enter name: " LOGIN
done

sed -i "/^# BEGIN_PEER $LOGIN/,/^# END_PEER $LOGIN$/d" $CHAPSECRETS
rm -rf $DIR/ipsec/akun/"$LOGIN"
rm -rf /root/akun/l2tp/"$client.txt"

echo "$LOGIN deleted!"
