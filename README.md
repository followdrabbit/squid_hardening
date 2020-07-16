# Hardening recommendations for proxy Squid
Security settings are not limited to specific equipment or operation system configurations. This document contains security recommendations that should be considered for a squid proxy.

## Hardening Checklist for proxy Squid
| Type | Recommendation | Reason |
| ------- | ------- | ------- |
| Installation | It is critical that Squid be installed on a dedicated server located in a secure network. | If your proxy server is easily accessible to anyone, it then becomes vulnerable and a very attractive target. Firewalls are likely to trust proxy servers for some ports and protocols
| Installation | Get rid of any services that would not be used| Attacks are often performed through unused running services. This topic os cover on [CIS](https://www.cisecurity.org/cis-benchmarks/) and [NIST](https://www.nist.gov/publications/guide-general-server-security) checklist for Hardening.
| Installation | Create a sandbox user specifically dedicated to Squid. Assign an invalid shell to the sandbox user.| There is no need for squid to use bash.
| Installation | Squid requires directories to store cache data locally. Ensure that only the Squid user (sandbox) has read/write/execute access to these directories. Suggested to set the sticky bit in the directories’ permissions.| Having the sticky bit set prevent cache data from being deleted or altered by another user or other processes on the system. Check if cache is needed, if don't disable.
| Configuration | Change the default port number to any other number available in the high range and configure the squid service to listen on a specific ip address | Since port scanners are likely to assume 3128 and 8080 for proxy service, running Squid on any other free port in the high range will make its detection more difficult. If your server has more than one interface, you can restrict the IP address on which it listens to. If more than one interface is used, Squid supports multiple http_port lines.
| Configuration | Configure the limits on the size of cached objects | The primary goal of this option is to optimize the cache/HIT ratio. This option is also interesting in a security standpoint since it helps to protect against a denial of service.
| Configuration | Configure trustable name servers to be used by squid. | A compromised DNS server is often used by attackers to divert proxy servers and certain Squid versions can be crashed by sending malformed DNS answers.
| Configuration | Set a value to request_header_max_size parameter | Most denial of service attacks against proxy servers are attempted by sending them headers larger than what they can handle. This parameter should be used with precaution.
| Configuration | Set a value to client_lifetime parameter | The client_lifetime sets the maximum time a client is allowed to be bound to a Squid process. This protects your server from having too many sockets opened. An attacker can take advantage of a lifetime that is too long by opening a large number of sockets.
| Configuration | Set a value to pconn_timeout parameter | The pconn_timeout sets the maximum time for idle persistent connections. This protects your server from having too many sockets opened thate are not in use.
| Configuration | Use ACL to restrict the acess to you network and define the trusted ports | From a security perspective, one of the most important section of the configuration file is the access control list (ACL’s). This controls whatever a particular HTTP request is permitted or denied. Two parameters are required to achieve this control; acl defines the element to be controlled and http_access permits or denies the element.
| Configuration | Put a deny rule as last line on ACL | This will make whatever is not explicitly permitted to be denied by default and is a good practice.
| Configuration | Implement an authentication method. | Squid supports authentication and its usage is strongly encouraged. Various authentication modules such as NCSA, LDAP and NTLM are supported by Squid and referred to as helpers.
| Configuration | Set a value to authenticate_ttl parameter | When authentication is used, the parameter authenticate_ttl defines how long Squid is to remember client authentication information. This option forces the client to re-authenticate himself after the specified period (TTL) has expired.
| Configuration | Set a value to authenticate_ip_ttl parameter | The parameter authenticate_ip_ttl defines how long a client’s authentication should be bound to a particular IP address. The purpose of this parameter is to discourage people from sharing their passwords among themselves. The downside of using this parameter is it can inadvertently block legitimate access to some clients where IP addresses are subject to change regularly such as dialup users.
| Configuration | Set cache_effective_user and cache_effective_group parameters to dedicated sandbox user | The cache_effective_user and cache_effective_group options specify under which user and group Squid will be running. The defaults are set to user and group nobody. These values are to be changed to the dedicated (sandbox) user as recommended earlier.
| Configuration | Change the default value to coredump_dir parameter | 	The coredump_dir is used to indicate where Squid is to save its coredump files. If someone should find the coredump directory in its default location (/ or /usr), that person would be able to fill the partition in which the coredump files are saved and cause a denial of service. Since these coredump files can get very huge, make sure you change this option to a directory outside a partition critical for system operation.
| Configuration | Ensure that ignore_unknown_nameservers parameter is on | This option is on by default and should be left as such. 
| Restrict access to cachemgr.cgi interface or remove it | The cachemgr.cgi is a script that allows an administrator to obtain useful information such as DNS statistics, Cache hits, active connections etc. This script could be useful to an attacker due to the information it reveals. If this type of information is not required by your organization, disregard installing cachemgr.cgi script. On the other hand, if such information is required, use ACL or other methods to restringe acess to squid cache manager.
| Configuration | Disable forwarded_for | A web server does not see connection with the client but rather sees the connection with the proxy. To accommodate possible web server ACL’s based on client address, Squid has its own HTTP header called HTTP_FORWARD_FOR. Turning off this header gives you the advantage of hiding the client’s IP address on the internet which is a very good security practice.
| Configuration | Disable unused features like ICP, HTCP and SNMP | ICP and HTCP ports are used to communicate with other caches in a hierarchy and in most cases we don’t need these ports open, specifically if we've disabled the cache. SNMP is used for monitoring, but in the same way we did with ICP and HTCP ports, if it is not required, disable it.

## How to examples
This section contains examples to implement some of the recommendations cited before. This configuration must be put on squid.conf file

**Disabling caching completely**
```
cache deny all
```

**Changing the default port and setting a IP to Squid**
```
http_port 172.16.0.15:9584
```

**Setting a limit on the size of cached objects**
```
maximum_object_size 4096 MB - Default value
minimum_object_size 0 KB - Default value
```

**Configuring trustable name servers**
```
dns_nameservers 10.0.0.1 192.172.0.4
```
Use the parameter dns_nameservers if you want to specify a list of DNS name servers (IP adresses) to use instead of those given in your /etc/resolv.conf file.  

**Setting a limit to request_header_max_size**
```
request_header_max_size 64 KB
```

**Setting a limit to client_lifetime**
```
client_lifetime 1 day - Default value
```

**Setting a value to pconn_timeout**
```
pcon_timeout 1 minute - Default value
```

**Use ACL to restrict access to your network and define the trusted ports**
```
acl mynetwork src 172.16.0.0/12
http_access allow mynetwork
acl trusted_ports port 22 443 8080
http_access deny !trusted_ports
```

**Put a deny rule as last line on ACL**
```
acl all src 0.0.0.0/0.0.0.0
http_access deny all
```

**Set a value to authenticate_ttl**
```
authenticate_ttl 1 hour - Default value
```

**Set a value to authenticate_ip_ttl**
```
authenticate_ip_ttl 1 second - Default value
```

**Set cache_effective_user and cache_effective_group parameters to dedicated sandbox user**
```
cache_effective_user squid_user
cache_effective_group squid_group
```

**Change the default directory for coredump files**
```
cache_effective_user squid_user
cache_effective_group squid_group
```

**Turn on the ignore_unknown_nameserver parameter**
```
ignore_unknown_nameserver on
```

**Disable forwarder_for**
```
forwarder_for off
```

**Disable unused features like ICP, HTCP and SNMP**
```
icp_port 0
icp_access deny all
htcp_port 0
htcp_access deny all
snmp_port 0
snmp_access deny all
```