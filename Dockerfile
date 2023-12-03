FROM ghcr.io/penguincloud/core

RUN mkdir -p /opt/app
COPY . /opt/app
# Set the working directory
WORKDIR /opt/app

# Install Node.js (using NodeSource)
RUN ansible-playbook ansible/build.yml --connection=local

# Copy Gemfile and install gems
# COPY Gemfile Gemfile.lock ./
RUN /usr/local/bin/rbenv &&

# Install JavaScript dependencies
RUN yarn install

# Ruby ARG / ENV
ARG SECRET_KEY_BASE="defaultsecret"
ARG RAILS_ENV="production"
ARG RAILS_VERSION="3.2.2"
ARG RBENV_VERSION="1.2.0"
ARG RBENV_BUILDVERSION="20231114"
ENV SECRET_KEY_BASE="defaultsecret"
ENV RAILS_ENV="production"

# Precompile assets in production. 
# SECRET_KEY_BASE is needed for Rails to run in production for this step.
RUN bundle exec rake assets:precompile

user www-data

# Start the Rails app
CMD ["rails", "server", "-b", "0.0.0.0"]
