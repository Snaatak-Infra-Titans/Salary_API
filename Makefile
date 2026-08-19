APP_VERSION ?= v0.1.0
IMAGE_REGISTRY ?= quay.io/opstree
IMAGE_NAME ?= salary-api

# Build Salary API
build:
	mvn clean package

# Run checkstyle
fmt:
	mvn checkstyle:checkstyle

# Run tests
test:
	mvn test

docker-build:
	docker build -t ${IMAGE_REGISTRY}/${IMAGE_NAME}:${APP_VERSION} -f Dockerfile .

docker-push:
	docker push ${IMAGE_REGISTRY}/${IMAGE_NAME}:${APP_VERSION}

# Read database URL from migration.json unless DATABASE_URL is passed
DATABASE_URL ?= $(shell [ -f migration.json ] && jq -r '.database' migration.json)

# Run Salary DB migrations
run-migrations:
	@echo "Running Salary DB Migrations..."
	@echo "Database: $(DATABASE_URL)"

	migrate \
		-source file://migration \
		-database "$(DATABASE_URL)&x-migrations-table=salary_schema_migrations" \
		up
