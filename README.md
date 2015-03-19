#Resolving hosts using dnsmasq in Docker

This is a spike for running dnsmasq to resolve docker hosts.  Docker links require dependent components to be rebuilt if a container changes or is redeployed.  Providing a DNS server removes this limitation (only the DNS server needs restarting if links are updated rather than everything in the link tree).  Dnsmasq automatically propogates /etc/hosts entries, therefore using docker links to define these hosts allows nodes to resolve other containers using the link alias.

#Example Usage

```
docker build -t dnsmasq .
docker run --name=service1 --dns=172.17.42.1 -t -i -d java:7-jre /bin/bash
docker run --name=service2 --dns=172.17.42.1 -t -i -d java:7-jre /bin/bash
docker run --name=mydns -p 53:53/tcp -p 53:53/udp -p 67:67/udp -t -i --link service1:s1 --link service2:s2 -d dnsmasq
```

172.17.42.1 - this is the docker0 network interface ip address

Docker containers can now talk to each other via the link alias defined in mydns 

```
docker exec -i -t service1 bin/bash
ping s2
64 bytes from 172.17.0.3: icmp_seq=0 ttl=64 time=0.064 ms
64 bytes from 172.17.0.3: icmp_seq=1 ttl=64 time=0.183 ms
64 bytes from 172.17.0.3: icmp_seq=2 ttl=64 time=0.274 ms
```

This can be extended to auto-discover containers by listening to docker start/stop events.