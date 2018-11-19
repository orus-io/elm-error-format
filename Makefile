help:  ## Display this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

run:  ## Run demo app
	export PATH=$$(pwd)/node_modules/.bin:$$PATH && \
		cd src && \
			sysconfcpus -n 1 \
			elm-live \
			--port=8044 \
			--pushstate \
			-- \
			Main.elm \
			--output app.js \
			--warn \
			--debug

test:  ## Run tests
	export PATH=$$(pwd)/node_modules/.bin:$$PATH && \
		elm-test

coverage:  ## Run tests with coverage
	export PATH=$$(pwd)/node_modules/.bin:$$PATH && \
		elm-coverage --open

clean:  # Remove all elm/node related directories
	rm -rf ./elm-stuff ./node_modules ./src/elm-stuff ./tests/elm-stuff
