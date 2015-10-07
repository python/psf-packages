deb:
	$(eval ITERATION := $(lastword $(subst -, , $(VERSION))))
	$(eval VERSION2 := $(patsubst %-$(ITERATION), %, $(VERSION)))
	$(eval TMPDIR := $(shell mktemp -d))
	wget https://www.stunnel.org/downloads/stunnel-5.23.tar.gz -O $(TMPDIR)/stunnel-5.23.tar.gz
	tar zxf $(TMPDIR)/stunnel-5.23.tar.gz -C $(TMPDIR)/
	cd $(TMPDIR)/stunnel-5.23 && \
		./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var
	cd $(TMPDIR)/stunnel-5.23 && make
	mkdir -p $(TMPDIR)/build
	cd $(TMPDIR)/stunnel-5.23 && make install DESTDIR=$(TMPDIR)/build
	fpm -s dir -t deb -n $(PACKAGE) -v $(VERSION2) --iteration $(ITERATION) \
		-C $(TMPDIR)/build \
		-d "libssl1.0.0 >= 1.0.0" \
		-d "libc6 >= 2.14" \
		--deb-init $(TMPDIR)/build/usr/share/doc/stunnel/examples/stunnel.init \
		etc usr/bin usr/lib usr/share var/lib
