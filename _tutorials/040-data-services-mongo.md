docker run --detach --publish-all mongo:3.0.6
docker ps --latest
docker port $(docker ps --quiet --latest) 27017

For our containerized MongoDB service, note how we don't care what it's called, where it runs, or what port it uses.

export GB_MONGO_HOST=$(docker port $(docker ps --quiet --latest) 27017 | cut -f 1 -d ':')
export GB_MONGO_PORT=$(docker port $(docker ps --quiet --latest) 27017 | cut -f 2 -d ':')
export GB_MONGO_DB=guestbook
export GB_MONGO_DB_USERNAME=guestbook-test
export GB_MONGO_DB_PASSWORD=guestbook-test-password

env | grep GB_

docker run -it --rm mongo:3.0.6 \
  mongo --eval 'db.getSiblingDB("'"$GB_MONGO_DB"'").createUser({"user": "'"$GB_MONGO_DB_USERNAME"'", "pwd": "'"$GB_MONGO_DB_PASSWORD"'", "roles": [ "readWrite" ]})' $GB_MONGO_HOST:$GB_MONGO_PORT

Note: Tap Enter

git clone https://github.com/rackerlabs/guestbook-mongo.git
cd guestbook-mongo
docker build --tag="guestbook-mongo:1.0" .
docker run --detach \
  --env GB_MONGO_HOST=$GB_MONGO_HOST \
  --env GB_MONGO_PORT=$GB_MONGO_PORT \
  --env GB_MONGO_SSL=$GB_MONGO_SSL \
  --env GB_MONGO_DB=$GB_MONGO_DB \
  --env GB_MONGO_DB_USERNAME=$GB_MONGO_DB_USERNAME \
  --env GB_MONGO_DB_PASSWORD=$GB_MONGO_DB_PASSWORD \
  --publish 5000:5000 \
  guestbook-mongo:1.0

docker ps --latest

docker logs $(docker ps --quiet --latest)

open http://$(docker port $(docker ps --quiet --latest) 5000)

docker ps --quiet -n=-2

docker rm --force $(docker ps --quiet -n=-2)

export GB_MONGO_HOST=iad-mongosX.objectrocket.com
export GB_MONGO_PORT=54321
export GB_MONGO_SSL=True
export GB_MONGO_DB=guestbook
export GB_MONGO_DB_USERNAME=guestbook-admin
export GB_MONGO_DB_PASSWORD=guestbook-admin-password

docker run --detach \
  --env GB_MONGO_HOST=$GB_MONGO_HOST \
  --env GB_MONGO_PORT=$GB_MONGO_PORT \
  --env GB_MONGO_SSL=$GB_MONGO_SSL \
  --env GB_MONGO_DB=$GB_MONGO_DB \
  --env GB_MONGO_DB_USERNAME=$GB_MONGO_DB_USERNAME \
  --env GB_MONGO_DB_PASSWORD=$GB_MONGO_DB_PASSWORD \
  --publish 5000:5000 \
  guestbook-mongo:1.0

docker ps --latest

docker logs $(docker ps --quiet --latest)

open http://$(docker port $(docker ps --quiet --latest) 5000)

docker rm --force $(docker ps --quiet --latest)

Don't forget to remove your MongoDB if you're not using it.

## Troubleshooting

docker run -it --rm mongo:3.0.6 /bin/bash
