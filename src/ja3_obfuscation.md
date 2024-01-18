# Obfuscating JA3 Hashes with HAProxy
## Summary

JA3 fingerprinting is a methodology for identifying attributes about a TLS connection and representing that information with an MD5 hash. These hashes can used to identify non-standard and potentially malicious traffic on a network. For example, the JA3 hash for most legitimate web traffic will be identical, whereas that of C2 traffic could either be unique and thus questionable, or exactly the same as other known C2 signatures and easily identifiable. While not exceptionally reliable, this is often used as a detection rule for intrusion detection systems (such as Suricata), or as an analytic for data driven monitoring and so should be obfuscated if possible.

The solution to the abnormal JA3 hashes produced by C2 traffic is to encapsulate it within HTTPS traffic directed towards a load balancer. The load balancer will then redirect the encapsulated C2 traffic to the C2 server, and when the C2 server reaches back to the load balancer it will once again get redirected under the guise of legitimate traffic. Since load balancers are very common technologies within web stacks, this will allow the JA3 hash of C2 traffic to blend in with normal web traffic. Furthermore, since this is a layer in front of the C2 server, it should be platform agnostic provided that the C2 platform supports HTTPS beaconing.


## Prerequisites
* Linux VM (Ideally with the apt package manager)
* A C2 server (Can be running on the aforementioned Linux VM)

## Setup
### Initial Setup
1. Install haproxy via your distribution's package manager (`sudo apt-get install haproxy` with apt) 
2. Open the haproxy configuration file at `/etc/haproxy/haproxy.cfg` using your text editor of choice
```
The file layout will look like this:
====

global
	xxxx
	xxxx

defaults
	xxxx
	xxxx

====

For the purposes of this guide, the non-tabbed portions (global and default) will be referred to as sections. You can ignore the two existing sections, but editing them may be useful for fine tuning.
```
3. At the bottom of the file, add a new section called `frontend myfrontend` and format it as laid out below. This will be the address and port that the load balancer is listening for traffic on.
```
defaults
	xxxx
	xxxx

frontend myfrontend
	default_backend myserver
	bind 0.0.0.0:8080
```
4. Save and exit the configuration file and restart HAProxy using `systemctl restart haproxy`, if you see any errors you likely have a syntax error.
5. Verify that your configuration is working by running `curl 127.0.0.1:8080`. This command should return a `503 Service Unavailable "No server is available to handle this request."` error.
6. Re-open the configuration file and add the following configuration at the end of the file. This will be the destination where traffic will be redirected to.
```
frontend myfrontend
	default_backend myserver
	bind 0.0.0.0:8080

backend myserver
	server server1 127.0.0.1:8000
```
7. Save and exit the configuration file and restart HAProxy using `systemctl restart haproxy`.
8. In another terminal/tab, start a python webserver with the command `python3 -m http.server --bind 127.0.0.1 8000`.
9. Verify the redirection using `curl 127.0.0.1:8080`. The output of this command should be the filenames in the directory where the webserver is being hosted. If you are still getting a `503 Service Unavailable` error, ensure that you have the `default_backend` under the `frontend` section set correctly.
10. You can now redirect unencrypted HTTP traffic by adjusting the frontend and backend values.
### Generating SSL Certificates
1. Generate a private key using `openssl genpkey -algorithm RSA -out pkey.pem.
2. Generate a certificate signing request using `openssl req -new -key pkey.pem -out csr.pem`.
3. Generate a self signed certificate using `openssl x509 -req -days 365 -in csr.pem -signkey pkey.pem -out cert.pem.
4. Create a new file using `touch tls.pem`.
5. Add the cert.pem to tls.pem using `cat cert.pem >> tls.pem`.
6. Add the private key information to tls.pem using `sudo cat pkey.pem >> tls.pem`.

### Configuring TLS
1. Open the configuration file from earlier and modify the following lines. This will change the frontend bind address to be any interface on port 443, and will assign the listed ssl cert to the port.
```
frontend myfrontend
	default_backend myserver
	bind 0.0.0.0:443 ssl cert /path/to/tls.pem

```
2. Save and exit the configuration file and restart HAProxy using `systemctl restart haproxy`. If you get an error, ensure that you properly combined the two .pem files from earlier into a single file, and that your path is correct.

## Execution
1. Modify the configuration file from earlier to be representative of your listener address as follows (the pound signs are just comments).
```
backend myserver
	server server1 127.0.0.1:6969
	# ^ Your C2 listener will be set up on this port (6969) 
```
2. Generate an http/s (https if your platform supports it) beacon pointing towards the server running HAProxy and your C2 server at the port defined in your frontend section (443 using the example from setup)
3. Set up an http/s listener on your C2 server listening on the port defined in the backend section (6969 using the example from earlier)
4. Execute your beacon on a target box and ensure you get a callback. If you want to verify that the traffic is TLS, observe the traffic in wireshark and ensure that you are seeing a `Client Hello` followed by a `Server Hello` pointed towards the HAProxy frontend address and port. Wireshark should also show you the JA3 hash.
#### Indicators of Compromise
The indicators of compromise for this action would be the same as HTTPS beaconing, but it should help in defeating JA3 hash based detection. The traffic will likely be using a self signed SSL certificate, which may be an indicator that the destination is illegitimate.
