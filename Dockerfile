FROM ghcr.io/penguincloud/core

RUN mkdir -p /opt/app
COPY . /opt/app
# Set the working directory
WORKDIR /opt/app

# Install Node.js (using NodeSource)
RUN ansible-playbook penguinz/build.yml --connection=local

# Copy Gemfile and install gems
# COPY Gemfile Gemfile.lock ./
RUN /usr/local/bin/rbenv &&

# Install JavaScript dependencies
RUN yarn install

# ARG for SECRET_KEY_BASE
ARG SECRET_KEY_BASE=defaultsecret

# Precompile assets in production. 
# SECRET_KEY_BASE is needed for Rails to run in production for this step.
RUN RAILS_ENV=production SECRET_KEY_BASE=${SECRET_KEY_BASE} bundle exec rake assets:precompile


user www-data

# Start the Rails app
CMD ["rails", "server", "-b", "0.0.0.0"]
