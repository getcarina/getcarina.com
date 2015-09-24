FROM grahamc/jekyll:latest

# Install whatever is in your Gemfile
WORKDIR /tmp
ADD Gemfile /tmp/
ADD Gemfile.lock /tmp/
RUN bundle install

# Change to the jekyll site directory
WORKDIR /src
