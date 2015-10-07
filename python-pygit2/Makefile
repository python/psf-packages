deb:
	$(eval ITERATION := $(lastword $(subst -, , $(VERSION))))
	$(eval VERSION2 := $(patsubst %-$(ITERATION), %, $(VERSION)))
	$(eval TMPDIR := $(shell mktemp -d))
	wget https://github.com/libgit2/libgit2/archive/v0.23.3.tar.gz -O $(TMPDIR)/v0.23.3.tar.gz
	tar zxf $(TMPDIR)/v0.23.3.tar.gz -C $(TMPDIR)
	cd $(TMPDIR)/libgit2-0.23.3 && mkdir build
	cd $(TMPDIR)/libgit2-0.23.3/build && \
		cmake -DBUILD_SHARED_LIBS=OFF \
			  -DCMAKE_C_FLAGS=-fPIC \
			  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
			  -DBUILD_CLAR=OFF \
			  -DTHREADSAFE=ON \
			  ..
	cd $(TMPDIR)/libgit2-0.23.3/build && cmake --build .
	virtualenv -ppython2 $(TMPDIR)/venv
	$(TMPDIR)/venv/bin/pip install cffi
	LDFLAGS="-L$(TMPDIR)/libgit2-0.23.3/build -lssl -lcrypto" \
		CFLAGS="-I$(TMPDIR)/libgit2-0.23.3/include" \
		fpm -s python -t deb -n $(PACKAGE) -v $(VERSION2) --iteration $(ITERATION) \
			--python-bin $(TMPDIR)/venv/bin/python \
			--python-easyinstall $(TMPDIR)/venv/bin/easy_install \
			--python-install-lib /usr/local/lib/python2.7/dist-packages \
			--verbose pygit2
