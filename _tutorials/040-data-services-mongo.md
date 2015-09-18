docker run --detach --publish-all mongo:3.0.6
docker ps --latest
docker port $(docker ps --quiet --latest) 27017

For our containerized MongoDB service, note how we don't care what it's called, where it runs, or what port it uses.

export GB_MONGO_HOSTNAME_AND_PORT=$(docker port $(docker ps --quiet --latest) 27017)
export GB_MONGO_DB=guestbook

env | grep GB_

git clone https://github.com/rackerlabs/guestbook-mongo.git
cd guestbook-mongo
docker build --tag="guestbook-mongo:1.0" .
docker run --detach \
  --env GB_MONGO_HOSTNAME_AND_PORT=$GB_MONGO_HOSTNAME_AND_PORT \
  --env GB_MONGO_DB=$GB_MONGO_DB \
  --env GB_MONGO_DB_USERNAME=$GB_MONGO_DB_USERNAME \
  --env GB_MONGO_DB_PASSWORD=$GB_MONGO_DB_PASSWORD \
  --env GB_MONGO_OPTIONS=$GB_MONGO_OPTIONS \
  --publish 5000:5000 \
  guestbook-mongo:1.0

docker ps --latest

docker ps --quiet -n=-2

docker rm --force $(docker ps --quiet -n=-2)

export GB_MONGO_HOSTNAME_AND_PORT=iad-mongosX.objectrocket.com:54321
export GB_MONGO_DB_USERNAME=guestbook-admin
export GB_MONGO_DB_PASSWORD=my-guestbook-admin-password
export GB_MONGO_OPTIONS=ssl=true

docker run --detach \
  --env GB_MONGO_HOSTNAME_AND_PORT=$GB_MONGO_HOSTNAME_AND_PORT \
  --env GB_MONGO_DB=$GB_MONGO_DB \
  --env GB_MONGO_DB_USERNAME=$GB_MONGO_DB_USERNAME \
  --env GB_MONGO_DB_PASSWORD=$GB_MONGO_DB_PASSWORD \
  --env GB_MONGO_OPTIONS=$GB_MONGO_OPTIONS \
  --publish 5000:5000 \
  guestbook-mongo:1.0

docker ps

docker rm --force $(docker ps --quiet --latest)

Don't forget to remove your MongoDB if you're not using it.
