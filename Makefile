PKGS = consul

debs:
	-for d in $(PKGS); do (cd $$d; $(MAKE) deb ); done
