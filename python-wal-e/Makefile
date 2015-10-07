deb:
	$(eval ITERATION := $(lastword $(subst -, , $(VERSION))))
	$(eval VERSION2 := $(patsubst %-$(ITERATION), %, $(VERSION)))
	fpm -s python -t deb -n $(PACKAGE) -v $(VERSION2) --iteration $(ITERATION) \
		--no-auto-depends \
		-d 'python-gevent >= 0.13.1' \
		-d 'python-boto >= 2.6.0' \
		-d 'python-swiftclient >= 1.8.0' \
		-d 'python-keystoneclient >= 0.4.2' \
		wal-e
