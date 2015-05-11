FROM ruby:2.1.6
MAINTAINER Yevgeniy Brikman <jim@ybrikman.com>

# Install Node.js and NPM
RUN apt-get update
RUN apt-get install -y nodejs npm
RUN ln -s /usr/bin/nodejs /usr/bin/node

# Install grunt
RUN npm install -g grunt-cli

# Install Jekyll
RUN gem install jekyll

# Copy the package.json file into the image and run npm install in a
# way that will be cached. See: http://bitjudo.com/blog/2014/03/13/building-efficient-dockerfiles-node-dot-js/
ADD package.json /tmp/package.json
RUN cd /tmp && npm install
RUN mkdir -p /src && cp -a /tmp/node_modules /src/

# Source code will be in /src
VOLUME ["/src"]
WORKDIR /src
ADD . /src

# Jekyll runs on port 4000 by default
EXPOSE 4000

# Have to force "watch" and "polling" as inotify doesn't work via Docker
CMD ["npm", "start"]