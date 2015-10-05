PKGS = consul/0.5.2 consul-template/0.10.0


.PHONY: debs clean


all: debs upload


.Packages:
	wget https://packagecloud.io/psf/infra/ubuntu/dists/trusty/main/binary-amd64/Packages -O .Packages


%.deb:
	$(eval PACKAGE := $(firstword $(subst _, , $(notdir $@))))
	$(eval VERSION := $(word 2, $(subst _, , $(notdir $@))))
	$(MAKE) -C $(@D) deb PACKAGE=$(PACKAGE) VERSION=$(VERSION)


debs: $(foreach d, $(PKGS), $(firstword $(subst /, , $(d)))/$(firstword $(subst /, , $(d)))_$(lastword $(subst /, , $(d)))_amd64.deb)


%.deb.upload: %.deb .Packages
	$(eval EXISTS := $(shell grep $(notdir $<) .Packages))
ifeq ($(EXISTS), )
	package_cloud push psf/infra/ubuntu/trusty $<
endif


upload: $(foreach d, $(PKGS), $(firstword $(subst /, , $(d)))/$(firstword $(subst /, , $(d)))_$(lastword $(subst /, , $(d)))_amd64.deb.upload)


clean:
	rm -f .Packages
	find . -name '*.deb' -delete
