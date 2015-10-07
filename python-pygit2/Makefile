deb:
	$(eval ITERATION := $(lastword $(subst -, , $(VERSION))))
	$(eval VERSION2 := $(patsubst %-$(ITERATION), %, $(VERSION)))
	$(eval TMPDIR := $(shell mktemp -d))
	wget https://www.openssl.org/source/openssl-1.0.2d.tar.gz -O $(TMPDIR)/openssl-1.0.2d.tar.gz
	tar zxf $(TMPDIR)/openssl-1.0.2d.tar.gz -C $(TMPDIR)
	cd $(TMPDIR)/openssl-1.0.2d && ./config no-shared no-ssl2 no-ssl3 no-comp no-idea no-dtls no-psk no-srp
	cd $(TMPDIR)/openssl-1.0.2d && make depend && make
	wget https://github.com/libgit2/libgit2/archive/v0.23.3.tar.gz -O $(TMPDIR)/v0.23.3.tar.gz
	tar zxf $(TMPDIR)/v0.23.3.tar.gz -C $(TMPDIR)
	cd $(TMPDIR)/libgit2-0.23.3 && mkdir build
	cd $(TMPDIR)/libgit2-0.23.3/build && \
		cmake -DBUILD_SHARED_LIBS=OFF \
			  -DCMAKE_C_FLAGS=-fPIC \
			  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
			  -DBUILD_CLAR=OFF \
			  -DTHREADSAFE=ON \
			  -DOPENSSL_SSL_LIBRARY=$(TMPDIR)/openssl-1.0.2d/libssl.a \
			  -DOPENSSL_CRYPTO_LIBRARY==$(TMPDIR)/openssl-1.0.2d/libcrypto.a \
			  ..
	cd $(TMPDIR)/libgit2-0.23.3/build && cmake --build .
	virtualenv -ppython2 $(TMPDIR)/venv
	$(TMPDIR)/venv/bin/pip install cffi
	LDFLAGS="-L$(TMPDIR)/libgit2-0.23.3/build" \
		CFLAGS="-I$(TMPDIR)/libgit2-0.23.3/include" \
		fpm -s python -t deb -n $(PACKAGE) -v $(VERSION2) --iteration $(ITERATION) \
			--python-bin $(TMPDIR)/venv/bin/python \
			--python-easyinstall $(TMPDIR)/venv/bin/easy_install \
			--python-install-lib /usr/local/lib/python2.7/dist-packages \
			--verbose pygit2
