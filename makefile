TAG := ruby-3.1.2-development

.built: Dockerfile Gemfile
	docker build -t $(TAG) .
	touch .built

shell: .built
	docker run --rm \
		-w /app \
		-v $$(pwd):/app \
		-it $(TAG) bash