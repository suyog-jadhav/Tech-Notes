# 📡 Network Tools

| Tool | Purpose | Link |
|---|---|---|
| **Wireshark** | The standard GUI packet analyzer | https://www.wireshark.org |
| **tshark** | CLI version of Wireshark (scripting-friendly) | bundled with Wireshark |
| **tcpdump** | Lightweight CLI packet capture | https://www.tcpdump.org |
| **Nmap / Zenmap** | Port scanning & service enumeration | https://nmap.org |
| **Netcat (nc) / ncat / socat** | Swiss-army-knife networking, reverse shells, port forwarding | built-in / https://nmap.org/ncat |
| **Responder** | LLMNR/NBT-NS/MDNS poisoner for internal network attacks | https://github.com/lgandx/Responder |
| **Chisel** | Fast TCP tunneling over HTTP (pivoting) | https://github.com/jpillora/chisel |
| **ProxyChains** | Route tool traffic through proxies/pivots | https://github.com/haad/proxychains |

## Notes
- Learn to filter in Wireshark with expressions like `http.request`, `tcp.port==`, `dns`, and "Follow TCP/HTTP Stream" — this alone solves most Network-category CTF challenges.
- Netcat reverse/bind shells are foundational for Pwn and Web challenges that grant RCE.
