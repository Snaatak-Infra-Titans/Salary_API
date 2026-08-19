APP_VERSION ?= v0.1.0
IMAGE_REGISTRY ?= quay.io/opstree
IMAGE_NAME ?= salary-api

# Build
build:
	mvn clean package

# Code Quality
fmt:
	mvn checkstyle:checkstyle

test:
	mvn test

# Docker
docker-build:
	docker build -t ${IMAGE_REGISTRY}/${IMAGE_NAME}:${APP_VERSION} -f Dockerfile .

docker-push:
	docker push ${IMAGE_REGISTRY}/${IMAGE_NAME}:${APP_VERSION}

# Database Migration
# If DATABASE_URL is not supplied, read it from migration.json
DATABASE_URL ?= $(shell jq -r '.database' migration.json)

run-migrations:
	@echo "Running Salary DB Migrations..."
	@echo "Database: $(DATABASE_URL)"
	migrate -source file://migration -database "$(DATABASE_URL)&x-migrations-table=salary_schema_migrations" up
