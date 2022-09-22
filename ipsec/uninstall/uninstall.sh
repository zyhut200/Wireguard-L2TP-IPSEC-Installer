#!/usr/bin/env bash

if [[ "$EUID" -ne 0 ]]; then
	echo "Sorry, you need to run this as root"
	exit 1
fi

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

echo "Removing cron task..."
TMPFILE=$(mktemp crontab.XXXXX)
crontab -l > $TMPFILE

sed -i -e "\@/etc/iptables.rules@d" $TMPFILE
sed -i -e "\@/etc/xl2tpd/checkserver.sh@d" $TMPFILE

crontab $TMPFILE > /dev/null
rm $TMPFILE

rm /etc/xl2tpd/checkserver.sh

echo "Restoring sysctl parameters..."
cp -i $DIR/sysctl.conf /etc/sysctl.conf
sysctl -p
cat /etc/sysctl.d/*.conf /etc/sysctl.conf | sysctl -e -p -

echo "Restoring firewall..."
iptables-save | awk '($0 !~ /^-A/)||!($0 in a) {a[$0];print}' > /etc/iptables.rules
sed -i -e "/--comment IPSEC/d" /etc/iptables.rules
iptables -F
iptables-restore < /etc/iptables.rules
rm /etc/iptables.rules

echo "Restoring configs..."
echo
echo "Uninstall script has been completed!"
