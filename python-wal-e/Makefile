deb:
	$(eval ITERATION := $(lastword $(subst -, , $(VERSION))))
	$(eval VERSION2 := $(patsubst %-$(ITERATION), %, $(VERSION)))
	$(eval TMPDIR := $(shell mktemp -d))
	wget https://pypi.python.org/packages/source/w/wal-e/wal-e-0.8.1.tar.gz -O $(TMPDIR)/wal-e-0.8.1.tar.gz
	tar zxf $(TMPDIR)/wal-e-0.8.1.tar.gz -C $(TMPDIR)/
	cd $(TMPDIR)/wal-e-0.8.1 && \
		sed -i '/^azure.*/d' ./requirements.txt
	fpm -s python -t deb -n $(PACKAGE) -v $(VERSION2) --iteration $(ITERATION) \
		-C $(TMPDIR)/wal-e-0.8.1 \
		./setup.py
