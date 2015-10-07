deb:
	$(eval TMPDIR := $(shell mktemp -d))
	wget https://github.com/libgit2/libgit2/archive/v0.23.3.tar.gz -O $(TMPDIR)/v0.23.3.tar.gz
	tar zxf $(TMPDIR)/v0.23.3.tar.gz -C $(TMPDIR)
	cd $(TMPDIR)/libgit2-0.23.3 && mkdir build
	cd $(TMPDIR)/libgit2-0.23.3/build && \
		cmake -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release -DBUILD_CLAR=OFF -DTHREADSAFE=ON .. && \
		cmake --build .
	cd $(TMPDIR)/libgit2-0.23.3/build && ls
	cd $(TMPDIR)/libgit2-0.23.3 && ls
	LDFLAGS="-static -L$(TMPDIR)/libgit2-0.23.3/build" \
		CFLAGS="-I$(TMPDIR)/libgit2-0.23.3/include" \
		fpm -s python -t deb -n $(PACKAGE) -v $(VERSION) pygit2
