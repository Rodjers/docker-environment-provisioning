# docker-environment-provisioning
Scripts for provisioning docker runtime environments

## Getting started 
Run provisioning.sh to set up and environment with a Consul server, load balancer and four application servers. Then run infra-set-up.sh to start the application

Run this command to set up your shell to manage the swarm:
```bash
$ eval $(cat env) 
```
Then scale the application with the following command:
```bash
$ docker-compose scale gitlebook=<number of instances>
```
To clean up the environment run cleanup.sh
