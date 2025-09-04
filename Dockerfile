# Use the official Elixir image
FROM elixir:1.14-alpine

# Install system dependencies
RUN apk add --no-cache \
    build-base \
    nodejs \
    npm \
    git \
    inotify-tools \
    postgresql-client

# Create app directory
WORKDIR /app

# Set environment variables
ENV MIX_ENV=docker

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Copy mix files
COPY mix.exs mix.lock ./

# Install dependencies
RUN mix deps.get && mix deps.compile

# Copy everything else
COPY . .

# Get dependencies again in case mix.exs changed
RUN mix deps.get

# Compile the project
RUN mix compile --no-validate-compile-env

# Expose port
EXPOSE 4000

# Start the Phoenix server
CMD ["sh", "-c", "mix deps.get && mix phx.server"]