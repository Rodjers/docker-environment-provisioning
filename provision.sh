#!/bin/bash
log() {
	echo "=== $1"
}

RANDOM_STRING=`cat /dev/urandom | env LC_CTYPE=C tr -cd 'a-f0-9' | head -c 4`

echo $RANDOM_STRING > id;

# you probably don't want to change these
CONSUL_NAME=consul-$RANDOM_STRING
MACHINE_NAME=ms-swarm-master-$RANDOM_STRING

# create Consul
log "Creating Consul machine"
docker-machine create \
    -d virtualbox \
    $CONSUL_NAME


log "Starting Consul"

eval "$(docker-machine env $CONSUL_NAME)"
CONSUL_IP=$(docker-machine ip $CONSUL_NAME)
docker run -d --name $CONSUL_NAME -h $CONSUL_NAME \
		-p 8600:53/udp \
		-p 8400:8400 \
		-p 8500:8500 \
		progrium/consul \
		-server \
		-bootstrap
log "Consul IP address: $CONSUL_IP"

# create Swarm Master
log "Creating Swarm master machine"
docker-machine create \
    -d virtualbox \
    --swarm --swarm-master \
    --swarm-discovery=consul://$(docker-machine ip $CONSUL_NAME):8500 \
    --engine-opt="cluster-store=consul://$(docker-machine ip $CONSUL_NAME):8500" \
    --engine-opt="cluster-advertise=eth0:2376" \
    $MACHINE_NAME

#Create application servers
log "Creating application servers"
for i in {1..4}
do
  log "Creating app-server-$i-$RANDOM_STRING"

	docker-machine create -d virtualbox \
  --swarm \
  --swarm-discovery=consul://$(docker-machine ip $CONSUL_NAME):8500 \
  --engine-label instance=appserver \
  --engine-opt="cluster-store=consul://$(docker-machine ip $CONSUL_NAME):8500" \
  --engine-opt="cluster-advertise=eth0:2376" \
  app-server-$i-$RANDOM_STRING
done

