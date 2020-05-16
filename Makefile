.PHONY: test release upload
test:
	rake

release:
	@rm -rf salesfly-*.gem
	gem build salesfly.gemspec

upload:
	gem push salesfly-*.gem	