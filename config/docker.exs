import Config

# Docker Development Environment Configuration
#
# This is a custom environment configuration for Docker-based development.
# It provides the minimal configuration needed for Docker containers without
# the complications of importing dev.exs settings that don't work in containers.
#
# Usage: Set MIX_ENV=docker when running in Docker containers

# Configure your database for Docker networking
config :tetris, Tetris.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "db",
  database: "tetris_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# Configure endpoint for Docker container access
config :tetris, TetrisWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4000],
  check_origin: false,
  code_reloader: false,
  debug_errors: true,
  secret_key_base: "Ss5HB2DGAky19nHZYVbNipfz9IfaWHRf8cNMXGVcXNyRK+1tm2cBAAawOCEGTnZn"

# Enable dev routes for dashboard and mailbox
config :tetris, dev_routes: true

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Phoenix LiveView configuration that works in Docker
config :phoenix_live_view,
  debug_heex_annotations: true

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false
