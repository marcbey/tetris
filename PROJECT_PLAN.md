# Tetris App Infrastructure & Deployment Plan

## Current State
- Elixir Phoenix application (Tetris game)
- Local development only
- No containerization
- No CI/CD pipeline
- No Database
- Enablee local development with Docker

## Immediate Goals
1. Create Terraform resources for a Github CI/CD Pipeline
2. Create a Gitlab pipeline to do `mix test` & `mix format`

## Next Goals
1. Production deployment of containers
2. AWS infrastructure with Terraform
3. Github CI/CD pipeline for creating the deployment images and the deployment
4. Integrate Claude AI into github CI/CD for reviewing PRs and responses on mentioning claude

## Step-by-Step Implementation
[Details for each step...]