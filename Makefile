.PHONY: test release upload
test:
	rake

build:
	@rm -rf salesfly-*.gem
	gem build salesfly.gemspec

deploy:
	#NOTE: apikey must be in ~/.gem/credentials
	gem push salesfly-*.gem	