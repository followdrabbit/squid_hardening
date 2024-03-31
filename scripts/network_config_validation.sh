#!/bin/bash

# Squid Network Configuration Check

# Check if Squid is listening on a non-default port
echo "Checking Squid listening port..."
# Replace '9584' with the non-default port you expect Squid to use
if netstat -lnt | grep -q '9584'; then
    echo "Squid is listening on the expected non-default port 9584."
else
    echo "Squid is not listening on the expected non-default port. Please check the configuration."
fi

# Check if trusted DNS servers are configured
echo "Checking configured DNS servers..."
# Replace with the expected DNS server addresses
trusted_dns=("10.0.0.1" "192.172.0.4")
dns_configured=$(grep "^dns_nameservers" /etc/squid/squid.conf)

if [[ -z "$dns_configured" ]]; then
    echo "No DNS servers are configured in Squid. Please check the configuration."
else
    echo "Configured DNS servers in Squid: $dns_configured"
    for dns in "${trusted_dns[@]}"; do
        if [[ "$dns_configured" == *"$dns"* ]]; then
            echo "Trusted DNS server $dns is configured."
        else
            echo "Trusted DNS server $dns is not configured. Please check the configuration."
        fi
    done
fi

# Check ACL configurations in Squid
echo "Checking ACL configurations..."
# Example check for an ACL entry; replace 'mynetwork' with the actual ACL name you use
acl_check=$(grep "^acl mynetwork" /etc/squid/squid.conf)

if [[ -z "$acl_check" ]]; then
    echo "ACL 'mynetwork' is not configured. Please check the configuration."
else
    echo "ACL 'mynetwork' is configured: $acl_check"
fi
