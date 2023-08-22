FROM ruby:3.0

# set working directory
WORKDIR /app

# install dependencies
RUN apt-get update -qq && \
      apt-get install -y nodejs postgresql-client

# install bundler
RUN gem install bundler:2.1.4

# copy the Gemfile and Gemfile.lock to the container
COPY Gemfile Gemfile.lock ./

# install the gems
RUN bundle install

# copy the rest of the application files to the container
COPY . .

# start the server
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
