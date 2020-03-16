# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

set :stage, :production
set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"

# Using remote cache to deploy
set :deploy_via, :remote_cache

server '54.204.82.42', user: 'ubuntu', roles: %w{app db web}

# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any  hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

# role :app, %w{deploy@example.com}, my_property: :my_value
# role :web, %w{user1@primary.com user2@additional.com}, other_property: :other_value
# role :db,  %w{deploy@example.com}



# Configuration
# =============
# You can set any configuration variable like in config/deploy.rb
# These variables are then only loaded and set in this stage.
# For available Capistrano configuration variables see the documentation page.
# http://capistranorb.com/documentation/getting-started/configuration/
# Feel free to add new variables to customise your setup.
set :rails_env, :production
set :pty, false

# number of unicorn workers
# set :unicorn_worker_count, 5


# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult the Net::SSH documentation.
# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
#
set :ssh_options, {
  keys: %w(/home/ronanlopes/Pems/bba-empilhadeiras.pem ~/.ssh/id_rsa),
  forward_agent: true,
  auth_methods: %w(publickey)
}

