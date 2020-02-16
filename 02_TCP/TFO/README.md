# TCP fast open

## Intro
TCP Fast Open (TFO) is an extension to speed up the opening of successive Transmission Control Protocol (TCP) connections between two endpoints. It works by using a TFO cookie (a TCP option), which is a cryptographic cookie stored on the client and set upon the initial connection with the server. When the client later reconnects, it sends the initial SYN packet along with the TFO cookie data to authenticate itself. If successful, the server may start sending data to the client even before the reception of the final ACK packet of the three-way handshake, thus skipping a round-trip delay and lowering the latency in the start of data transmission.

TFO support was included in Linux version 3.7, and as of version 3.13, it is enabled by default.

## Setup: 
Checking TFO on server:

`cat /proc/sys/net/ipv4/tcp_fastopen`

- 0 - disabled.
- 1 - only client (on outgoing connections) 
- 2 - only server (on listening sockets)
- 3 - client + server

Enabling TFO:

`echo "3" > /proc/sys/net/ipv4/tcp_fastopen`

Adding fastopen to nginx config:

`listen 80 fastopen=256`

enables “TCP Fast Open” for the listening socket and limits the maximum length for the queue of connections that have not yet completed the three-way handshake. 

## Checking:

- Client: 
  - `curl --tcp-fastopen -w "%{time_connect}\n" -I demo.site` 
  
  ~50ms

  - `curl -w "%{time_connect}\n" -I demo.site` 
  
  ~1ms

- Server: `grep '^TcpExt:' /proc/net/netstat | cut -d ' ' -f 84-90  | column -t`



## Issues: 
#### Middleboxes:
Expensive proprietary software that is rarely updated might stand beetween the end user and the server (caches, firewall, proxies, routers)

`lwn.net` report:
“about 5% of the systems on the net will drop SYN packets containing unknown options or data."

If an error occurs while setting up a TFO connection, a retry without TFO is required, which on average leads to an increase in time, therefore in Chrome and Firefox TFO is turned off by default.

- firefox: `about:config network.tcp.tcp_fastopen_enable`
- chrome: `chrome://flags/#enable-tcp-fast-open`


#### Tracking

Using a unique cookie allows servers using TFO to track users. For example, if a user visits a site, then opens an incognito window and goes to the same site, the same TFO cookie will be used in both windows.
The ability to use TFO to track users makes it unacceptable for most use cases.


## When is TFO useful?
When there is communication between two remote systems (server-server), for example, your client’s server communicates with your API. And if between middleware and middleboxes support TFO, and there are no tracking conserns by definition between you, then this is a great opportunity to save 50-100ms.


### Usefull links:
- https://www.keycdn.com/support/tcp-fast-open
- https://en.wikipedia.org/wiki/TCP_Fast_Open
- https://squeeze.isobar.com/2019/04/11/the-sad-story-of-tcp-fast-open/