deb:
	$(eval TMPDIR := $(shell mktemp -d))
	wget https://github.com/libgit2/libgit2/archive/v0.23.3.tar.gz -O $(TMPDIR)/v0.23.3.tar.gz
	tar zxf $(TMPDIR)/v0.23.3.tar.gz -C $(TMPDIR)
	cd $(TMPDIR)/libgit2-0.23.3 && mkdir build
	cd $(TMPDIR)/libgit2-0.23.3/build && \
		cmake -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release -DBUILD_CLAR=OFF -DTHREADSAFE=ON ..
	cd $(TEMPDIR)/libgit2-0.23.3/build && \
		CFLAGS="-O3 -g -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -fPIC" \
		cmake --build .
	virtualenv -ppython2 $(TMPDIR)/venv
	$(TMPDIR)/venv/bin/pip install cffi
	LDFLAGS="-static -L$(TMPDIR)/libgit2-0.23.3/build" \
		CFLAGS="-I$(TMPDIR)/libgit2-0.23.3/include -O3 -g -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -fPIC" \
		fpm -s python -t deb -n $(PACKAGE) -v $(VERSION) \
			--python-bin $(TMPDIR)/venv/bin/python \
			--python-easyinstall $(TMPDIR)/venv/bin/easy_install \
			--python-install-lib /usr/local/lib/python2.7/dist-packages \
			--verbose pygit2
