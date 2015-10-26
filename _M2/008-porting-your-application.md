---
title: Port your Rails application to Carina
slug: port-your-rails-application
description: How to port your existing Rails application to Carina
featured: true
topics:
  - docker
  - intermediate
---
By now, you're beginning to understand Docker and how it can benefit your workflow and deployments. This tutorial walks you through porting an existing Rails application (along with PostgreSQL, Redis, and Sidekiq workers) to Docker and Rackspace Cloud Files.

### Prerequisites

This tutorial leverages the following tools:

* [Interlock](https://github.com/ehazlett/interlock) - HAProxy plug-in
* [PostgreSQL](http://www.postgresql.org/) - Standard database
* [Rackspace Cloud Files](https://developer.rackspace.com/docs/cloud-files/getting-started/) - Media storage
* [Redis](http://Redis.io/) - Key-value store for Sidekiq
* [Sidekiq](http://sidekiq.org/) - Background job processor

This tutorial requires that you have the following software and understanding:

* A working Docker environment
* An existing Rails app above version 2.0 with a Gemfile
* Knowledge of Ubuntu commands and systems

### Steps

1. Create a Dockerfile.

    The `Dockerfile`, an essential part of porting your application, tells Docker which commands to run, which packages to install to your container, and builds an image. An image is a snapshot of your application's current state.

    In the root directory of your Rails application, create a new file named `Dockerfile`, and then paste the following code into the file:

        ```ruby
        FROM ruby:2.2.1
        RUN apt-get update && apt-get install -y \
          autoconf \
          automake \
          bison \
          build-essential \
          curl \
          g++ \
          gawk \
          gcc \
          libc6-dev \
          libffi-dev \
          imagemagick \
          libgdbm-dev \
          libncurses5-dev \
          libpq-dev \
          libreadline6-dev \
          libsqlite3-dev \
          libssl-dev \
          libtool \
          libyaml-dev \
          make \
          nodejs \
          nodejs-legacy \
          npm \
          patch \
          patch \
          pkg-config \
          sqlite3 \
          vim \
          zlib1g-dev

        RUN npm install -g phantomjs
        RUN mkdir /myapp

        WORKDIR /tmp
        COPY Gemfile Gemfile
        COPY Gemfile.lock Gemfile.lock
        RUN bundle install

        ADD . /myapp
        WORKDIR /myapp

        ENV POSTGRES_PASSWORD mysecretpassword
        ENV POSTGRES_USER postgres

        EXPOSE 80
        ```

2. Update the config/database.yml file.

    Now that your base Docker image is ready, update your application's `RAILS_ROOT/config/database.yml` file to point to a new database host that you will create in the next steps.
    Use the following code to update the file:

        ```yaml
        development: &default
          adapter: postgresql
          encoding: unicode
          database: myapp_dev
          pool: 5
          username: <%= ENV['POSTGRES_USER'] %>
          password: <%= ENV['POSTGRES_PASSWORD'] %>
          host: <%= ENV['POSTGRES_HOST'] %>

        test:
          <<: *default
          database: myapp_test

        production:
          <<: *default
          database: myapp_prod
        ```

3. Store public assets.

    This example uses Rackspace's Cloud Files service to store static assets. Rails does not do a good job of serving static assets (Javascript, CSS, images), so you can leverage Rackspace's Cloud Files service to distribute our assets. *Note:* Cloud Files calls folders "containers". These are simply folders on a CDN and are not Docker containers. If you already have a public container, simply locate the HTTP link as these instructions demonstrate.

        1. Log in to the [Rackspace Cloud Control Panel](https://mycloud.rackspace.com/).
        1. In the menu bar at the top of the window, click *Storage > Files*.
        1. Click *Create Container*.
        1. In the pop-up box, provide a name for the container and select *Public (Enabled CDN)* as the type. Then, click *Create Container*.
        1. On the Containers page, click the gear icon next to your new container and select *View All Links*.
        1. Copy the HTTP link.
        1. Open the `RAILS_ROOT/config/environments/production.rb` file.
        1. Add the following line to the file, substituting the example link with the link that you just copied: `config.action_controller.asset_host = "http://2167823940-238946.rackcdn.com"`

4. Build your containers.

    1. Go to [https://app.getcarina.com](http://app.getcarina.com).
    1. Create a new cluster.
    1. After a moment or two, refresh the page. You should see a series of icons that you can use to download your cluster credentials.
    1. Download these credentials in a clusterName.zip file.
    1. Extract them to the `RAILS_ROOT/amphora` folder so that the following
    script can call `amphora/docker.env`.
    1. Create a script named `RAILS_ROOT/bin/launch_cluster` and add the following code to it:


        ```bash

        # Load the Rackspace Cloud Files credentials
        source amphora/docker.env

        # Clean up existing containers if necessary
        cleanContainers() {
          docker rm --force interlock
          docker rm --force db
          docker rm --force db_ambassador
          docker rm --force redis
          docker rm --force redis_ambassador
          docker rm --force sidekiq

          for i in {1..5}
          do
            docker rm --force web${i}
          done

        }

        # Build your app before deploys
        buildImage(){
          docker build -t myapp .
        }

        # Interlock is a HAProxy plugin. It automatically adds containers to its load balancer
        # if a `--hostname` is supplied when creating the container. Hostnames should be
        # identical across the containers you'd like to load balance.
        # The certs listed here are automatically provided in your cluster.
        interlock() {
          docker run -d \
            --name interlock \
            -p 80:80 \
            --volumes-from swarm-data \
            ehazlett/interlock \
            --swarm-url $DOCKER_HOST \
            --swarm-tls-ca-cert=/etc/docker/ca.pem  \
            --swarm-tls-cert=/etc/docker/server-cert.pem \
            --swarm-tls-key=/etc/docker/server-key.pem \
            --plugin haproxy start
        }

        # This function creates a PostgreSQL container and an ambassador
        # (read more about the ambassador pattern: https://docs.docker.com/articles/ambassador_pattern_linking)
        dbCluster() {
          # Start actual DB server on one Docker host
          docker run -d \
            --name db \
            -h db \
            -e POSTGRES_PASSWORD=mysecretpassword \
            postgres

          # Postgres container takes a few seconds to boot / insert defaults.
          sleep 5

          # DB ambassador
          # Then add an ambassador linked to the DB server, mapping a port to the outside world
          docker run -d \
            --link db:db \
            --name db_ambassador \
            -p 5432:5432 \
            svendowideit/ambassador
        }

        # This method will run your db-related rake tasks
        migrate() {
          docker run \
            --rm \
            -e RAILS_ENV=production \
            -e POSTGRES_HOST=$DB_SERVER \
            myapp rake db:create db:schema:load db:migrate db:seed
        }

        # Much like the DB cluster, we have a Redis container and an ambassador
        redisCluster() {
          docker run -d \
            --name redis \
            -p 6379 \
            -h redis \
            redis

          sleep 10

          # Redis ambassador
          docker run -d \
            --link redis:redis \
            --name redis_ambassador \
            -p 6379:6379 \
            svendowideit/ambassador
        }

        # Sidekiq is a background job runner for Rails. This container talks
        # to the Redis ambassador container.
        sidekiq() {
          docker run -d \
            --name sidekiq \
            --restart always \
            myapp bundle exec sidekiq
        }

        # This method boots up n number of web containers and sets the host name
        # so that Interlock can add them to the load balancer.
        webCluster() {
          for i in {1..5}
          do
            docker run -d \
              --name web${i} \
              -p 80 \
              -P \
              --hostname test.com \
              -e INTERLOCK_DATA='{"port": 80, "warm": true}' \
              -e POSTGRES_HOST=$DB_SERVER \
              myapp bundle exec thin start -D -e production -p 80
          done
        }

        # This method will precompile Asset Pipeline resources and sync them
        # to Rackspace Cloud Files (using asset_sync)
        syncAssets() {
          RAILS_ENV=production rake assets:precompile assets:sync
        }

        # Helper method to get public IP of a container
        ipFor() {
           docker inspect $1 | egrep -e ".*HostIp.*[0-9]" | cut -d \" -f 4
        }

        # The main method. This will boot all necessary containers and clusters.
        # Order is important as some functions rely on env vars to be present.
        # Errors are expected for removing containers the first time as they don't yet exist.
        bootstrap() {

          # cleanContainers

          buildImage

          interlock
          export INTERLOCK=$(ipFor "interlock")

          dbCluster
          export DB_SERVER=$(ipFor "db_ambassador")

          redisCluster
          export REDIS_SERVER=$(ipFor "redis_ambassador")

          sidekiq
          export SIDEKIQ=$(ipFor "sidekiq")

          migrate

          syncAssets

          webCluster
        }

        bootstrap
        ```

    1. Run the following command to make the script executable: `chmod u+x RAILS_ROOT/bin/launch_cluster`
    1. Run `$ RAILS_ROOT/bin/launch_cluster`

    Building the containers takes about 15 minutes the first time because the process must build the Rails application image and update and install `apt-get` packages. Expect an error for removing containers the first time, because they don't yet exist. Here's an example of what you will see while it runs:

        ```
        interlock
        db
        db_ambassador
        redis
        redis_ambassador
        sidekiq
        web1
        web2
        web3
        web4
        web5
        Sending build context to Docker daemon   703 kB
        Step 0 : FROM ruby:2.2.1
         ---> ef6e4b7dc7cd
        ...and so on...
        **********************************************
        Your application is available at: 104.130.0.114
        Please add this to /etc/hosts with a domain
        **********************************************
        ```

5. Source the `amphora/docker.env` locally from within the `RAILS_ROOT/amphora/` directory so that you can inspect your Carina containers: `./amphora/docker.env`

6. Add the cluster IP address to the host file on the computer where you're browsing to the cluster IP address.
    1. To find your cluster IP address, run the following command: `docker inspect interlock | egrep -e ".*HostIp.*[0-9]" | cut -d \" -f 4`
    1. Edit the `/etc/hosts` file and add the cluster IP address. Interlock uses the hostname to determine routing. Following is an example of the line to add:
    `104.130.0.17 test.com`

7. Launch the Rails application.
    After updating your `/etc/hosts` file, navigate to `test.com` in your browser. The Rails application should be displayed.

8. Monitor the cluster's performance.
    Interlock provides a web UI for monitoring. Visit `test.com/haproxy?stats`; the username is `stats` and the password is `interlock`.

### Troubleshooting

* If you get a permissions error when running `bin/launch_cluster`, make sure you have made the script executable with a `chmod` command.
* If you get a syntax error when running `bin/launch_cluster`, ensure you have copied and pasted the entire script from above, ending with bootstrap.
* If your Rails application isn't displayed after running the migration script, check for any errors in the docker logs for each container.
* If you see a 503 Service Unavailable error when going to test.com, check the `/etc/hosts` file entry.

### Resources

* [Interlock](https://github.com/ehazlett/interlock) - HAProxy plug-in
* [PostgreSQL](http://www.postgresql.org/) - Standard database
* [Rackspace Cloud Files](https://developer.rackspace.com/docs/cloud-files/getting-started/) - Media storage
* [Redis](http://redis.io/) - Key-value store for Sidekiq
* [Sidekiq](http://sidekiq.org/) - Background job processor

### Next Steps

Try another tutorial or migrate another Rails app.
