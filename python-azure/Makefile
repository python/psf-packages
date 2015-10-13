deb:
	$(eval ITERATION := $(lastword $(subst -, , $(VERSION))))
	$(eval VERSION2 := $(patsubst %-$(ITERATION), %, $(VERSION)))
	fpm -s python -t deb -n $(PACKAGE) -v $(VERSION2) --iteration $(ITERATION) azure
