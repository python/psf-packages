PKGS = consul
DEBS = $(wildcard */*.deb)

debs:
	for d in $(PKGS); do (cd $$d; $(MAKE) deb ); done

push:
	for d in $(DEBS); do (echo $$d); done
