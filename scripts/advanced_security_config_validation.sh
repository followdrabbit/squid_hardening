#!/bin/bash

# Squid Advanced Security Configuration Check

# Check cache object size limits
echo "Checking cache object size limits..."
# Replace '4096' with your maximum object size limit
max_object_size=$(grep "^maximum_object_size" /etc/squid/squid.conf)
if [[ "$max_object_size" == "maximum_object_size 4096 MB" ]]; then
    echo "Maximum object size is correctly set to 4096 MB."
else
    echo "Maximum object size is not correctly set. Current setting: $max_object_size"
fi

# Check client lifetime setting
echo "Checking client lifetime setting..."
# Replace '1 day' with your expected client lifetime setting
client_lifetime=$(grep "^client_lifetime" /etc/squid/squid.conf)
if [[ "$client_lifetime" == "client_lifetime 1 day" ]]; then
    echo "Client lifetime is correctly set to 1 day."
else
    echo "Client lifetime is not correctly set. Current setting: $client_lifetime"
fi

# Check persistent connection timeout setting
echo "Checking persistent connection timeout setting..."
# Replace '1 minute' with your expected timeout setting
pconn_timeout=$(grep "^pconn_timeout" /etc/squid/squid.conf)
if [[ "$pconn_timeout" == "pconn_timeout 1 minute" ]]; then
    echo "Persistent connection timeout is correctly set to 1 minute."
else
    echo "Persistent connection timeout is not correctly set. Current setting: $pconn_timeout"
fi

# Check for authentication method
echo "Checking for authentication method..."
# This is a basic check for NCSA authentication; adjust as needed for your environment
auth_param=$(grep "^auth_param basic program" /etc/squid/squid.conf)
if [[ -n "$auth_param" ]]; then
    echo "Authentication method is configured: $auth_param"
else
    echo "Authentication method is not configured. Please check the configuration."
fi
