# Hardening Recommendations for Proxy Squid

Security settings extend beyond specific equipment or operating system configurations. This document provides security recommendations for a Squid proxy, emphasizing the importance of comprehensive security measures.

## Hardening Checklist for Proxy Squid

| Type         | Recommendation                                                                                         | Reason                                                                                                                                                         |
|--------------|--------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Installation | Install Squid on a dedicated server in a secure network.                                               | A proxy server accessible to outsiders is vulnerable and a target. Firewalls may trust it for certain ports and protocols, increasing risk.                     |
| Installation | Remove unnecessary services.                                                                           | Unused services can be exploited. Refer to the [CIS](https://www.cisecurity.org/cis-benchmarks/) and [NIST](https://www.nist.gov/publications/guide-general-server-security) hardening checklists. |
| Installation | Create a dedicated sandbox user for Squid with a non-shell account.                                    | Squid does not require shell access.                                                                                                                           |
| Installation | Ensure Squid has exclusive read/write/execute access to cache directories. Use the sticky bit.         | Prevents unauthorized alteration or deletion of cache data. Disable cache if not needed.                                                                       |
| Configuration| Use a non-standard, high-range port and bind Squid to specific IP addresses.                           | Reduces detectability by port scanners. Multiple `http_port` lines support binding to multiple IPs.                                                            |
| Configuration| Limit cached object size.                                                                              | Optimizes cache performance and prevents denial of service (DoS) attacks.                                                                                      |
| Configuration| Use trusted DNS servers.                                                                               | Protects against redirection by compromised DNS.                                                                                                               |
| Configuration| Limit `request_header_max_size`.                                                                       | Prevents DoS attacks from large headers. Use with caution.                                                                                                     |
| Configuration| Set `client_lifetime` to manage socket usage.                                                          | Prevents excessive socket opening, which can be exploited.                                                                                                     |
| Configuration| Configure `pconn_timeout` for idle persistent connections.                                             | Reduces risk of unused open sockets.                                                                                                                           |
| Configuration| Use ACLs to control network access and define trusted ports.                                           | Essential for security, controlling access based on HTTP requests.                                                                                             |
| Configuration| Always end ACLs with a deny rule.                                                                      | Ensures unspecified access is blocked by default, enhancing security.                                                                                          |
| Configuration| Implement authentication in Squid.                                                                     | Enhances security by verifying user identities. Squid supports NCSA, LDAP, and NTLM.                                                                           |
| Configuration| Adjust `authenticate_ttl` to control authentication duration.                                          | Forces re-authentication after the set period, enhancing security.                                                                                             |
| Configuration| Set `authenticate_ip_ttl` to manage IP-based authentication.                                           | Prevents password sharing and addresses dynamic IP issues for legitimate users.                                                                                |
| Configuration| Run Squid under a dedicated user and group.                                                            | Changes from default to a controlled access setting, increasing security.                                                                                      |
| Configuration| Relocate `coredump_dir` to a non-critical partition.                                                   | Prevents DoS attacks by filling disk space with coredump files.                                                                                                |
| Configuration| Enable `ignore_unknown_nameservers`.                                                                   | Protects against DNS spoofing.                                                                                                                                |
| Configuration| Restrict or remove cachemgr.cgi access.                                                                | Prevents revealing sensitive data to attackers. Use ACLs for restricted access if necessary.                                                                   |
| Configuration| Disable `forwarded_for` header.                                                                        | Enhances privacy by hiding client IP addresses on the internet.                                                                                                |
| Configuration| Disable unused features like ICP, HTCP, and SNMP.                                                      | Closes unnecessary ports and reduces attack surface.                                                                                                           |

## How-to Examples

These configurations should be added to the squid.conf file:

**Disabling caching:**

```bash
cache deny all
```

**Changing the default port and binding Squid to an IP:**

```bash
http_port 172.16.0.15:9584
```

**Limiting cached object size:**

```bash
maximum_object_size 4096 MB
minimum_object_size 0 KB
```

**Configuring trusted DNS servers:**

```bash
dns_nameservers 10.0.0.1 192.172.0.4
```

**Limiting request header size:**

```bash
request_header_max_size 64 KB
```

**Setting client lifetime:**

```bash
client_lifetime 1 day
```

**Configuring persistent connection timeout:**

```bash
pconn_timeout 1 minute
```

**Restricting network access with ACLs:**

```bash
acl mynetwork src 172.16.0.0/12
http_access allow mynetwork
acl trusted_ports port 22 443 8080
http_access deny !trusted_ports
```

**Denying unspecified access by default:**

```bash
acl all src 0.0.0.0/0.0.0.0
http_access deny
```

**Configuring authentication time-to-live (TTL):**

```bash
authenticate_ttl 1 hour
```

**Setting IP-based authentication TTL:**

```bash
authenticate_ip_ttl 1 second
```

**Specifying Squid's effective user and group:**

```bash
cache_effective_user squid_user
cache_effective_group squid_group
```

**Changing the directory for coredump files:**

```bash
coredump_dir /var/spool/squid_coredumps
```

**Ensuring Squid ignores unknown nameservers:**

```bash
ignore_unknown_nameserver on
```

**Disabling the `forwarded_for` header:**

```bash
forwarded_for off
```

**Disabling unused ICP, HTCP, and SNMP features:**

```bash
icp_port 0
icp_access deny all
htcp_port 0
htcp_access deny all
snmp_port 0
snmp_access deny all
```
