# docker-environment-provisioning
Scripts for provisioning docker runtime environments

## Set up 
Run provisioning.sh to set up and environment with a Consul server, load balancer and two application servers. Then run the following to start the application:

```bash
$ docker-compose up
```
Then scale the application with the following command:
```bash
$ docker-compose scale gitlebook=4
```
To clean up the environment run cleanup.sh
