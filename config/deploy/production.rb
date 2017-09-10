# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

# server "example.com", user: "deploy", roles: %w{app db web}, my_property: :my_value
# server "example.com", user: "deploy", roles: %w{app web}, other_property: :other_value
# server "db.example.com", user: "deploy", roles: %w{db}
server 'idcf-rails2', roles: %w{app web}
# server 'zikka-rails', user: 'vagrant', roles: %w{batch}, port: 22
set :user, 'thr3a'

set :rbenv_ruby, '2.4.0'
set :rbenv_type, :system
