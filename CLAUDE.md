# Tetris Project Guidelines

## Development Guidelines

- Comment code only on very complex code
- Always use the most idiomatic way to code
- Follow Elixir/Phoenix conventions and patterns
- Use pattern matching and functional programming idioms
- Prefer GenServer and OTP behaviors for state management
- Write tests for all public functions
- Use descriptive function and variable names
- Keep functions small and focused on single responsibilities

## Code Style

- Use `mix format` to maintain consistent formatting
- Follow standard Elixir naming conventions (snake_case for functions/variables, PascalCase for modules)
- Use `@doc` and `@spec` for public functions
- Group related functions together in modules
- Use `with` statements for pipeline operations that can fail

## Commands

### Development Server
```bash
mix phx.server
```

### Docker Development
```bash
# Build and start the application
docker compose up --build

# Start service (after first build)
docker compose up

# Start in detached mode
docker compose up -d

# Stop service
docker compose down

# View logs
docker compose logs -f web

# Execute commands in web container
docker compose exec web mix test
docker compose exec web mix format
docker compose exec web iex -S mix

# Rebuild after dependency changes
docker compose build web
```

### Testing
```bash
mix test
```

### Code Formatting
```bash
mix format
```

### Type Checking (if Dialyzer is added)
```bash
mix dialyzer
```

### Compilation
```bash
mix compile
```

### Setup (first time)
```bash
mix setup
```

<!-- ### Database Operations
```bash
mix ecto.migrate    # Run pending migrations
mix ecto.rollback   # Rollback last migration
mix ecto.reset      # Drop, create, migrate, and seed database
``` -->

<!-- ### Assets
```bash
mix assets.build    # Build assets for development
mix assets.deploy   # Build and minify assets for production
``` -->

## Project Structure

- `lib/tetris/` - Core business logic and game engine
- `lib/tetris_web/` - Phoenix web interface (controllers, live views, components)
- `lib/tetris/application.ex` - OTP application supervisor tree
- `assets/` - Frontend assets (JavaScript, CSS, images)
- `test/` - Test files (unit tests, integration tests)
- `priv/repo/migrations/` - Database migrations
- `priv/static/` - Static assets served by Phoenix
- `config/` - Application configuration files

## Testing Guidelines

- Write tests for all game logic
- Use ExUnit for unit tests
- Test both happy path and edge cases
- Mock external dependencies
- Aim for high test coverage on core game mechanics

## Git Workflow

- Create feature branches from `main`
- Write descriptive commit messages (no code notes in commit messages)
- Run tests before committing
- Format code before committing
- Keep commits focused and atomic

## Performance Considerations

- Use GenServer for game state management
- Implement proper supervision strategies
- Consider using ETS for fast lookups if needed
- Profile memory usage for long-running games
- Use Phoenix LiveView for real-time UI updates