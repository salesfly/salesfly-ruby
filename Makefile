.PHONY: test release upload
test:
	rake

build:
	@rm -rf salesfly-*.gem
	gem build salesfly.gemspec

deploy:
	gem push salesfly-*.gem	