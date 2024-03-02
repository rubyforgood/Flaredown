start: ## Start the project
	docker compose --profile dev up

stop: ## Stop the project
	docker compose --profile dev down

startNative: ## Start the react native project
	docker compose --profile native up

stopNative: ## Stop the react native project
	docker compose --profile native down

build: ## Build the project
	docker compose build backend

specs: ## Run the specs
	docker compose --profile dev run --rm backend rspec spec spec

console: ## Open a rails console
	docker compose --profile dev run --rm backend rails c

seed: ## Seed your database
	docker compose --profile dev run --rm backend bundle exec rails app:setup

help:
	@sed -n -E "s/(^[^ ]+):.* ## (.*)/`printf "\033[32m"`\1|`printf "\033[0m"` \2/p" $(MAKEFILE_LIST) | sort | column -t -s '|'
