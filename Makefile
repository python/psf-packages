AMD64_PKGS = consul/0.5.2 consul-template/0.10.0-2 python-cffi/1.2.1 stunnel/5.24-1
ALL_PKGS = python-diamond/4.0.195 python-dyn/1.4.2 python-wal-e/0.8.1-2


.PHONY: debs clean


all: upload


.Packages:
	wget https://packagecloud.io/psf/infra/ubuntu/dists/trusty/main/binary-amd64/Packages -O .Packages


%.deb:
	$(eval PACKAGE := $(firstword $(subst _, , $(notdir $@))))
	$(eval VERSION := $(word 2, $(subst _, , $(notdir $@))))
	$(MAKE) -C $(@D) deb PACKAGE=$(PACKAGE) VERSION=$(VERSION)


amd64-debs: $(foreach d, $(AMD64_PKGS), $(firstword $(subst /, , $(d)))/$(firstword $(subst /, , $(d)))_$(lastword $(subst /, , $(d)))_amd64.deb)


all-debs: $(foreach d, $(ALL_PKGS), $(firstword $(subst /, , $(d)))/$(firstword $(subst /, , $(d)))_$(lastword $(subst /, , $(d)))_all.deb)


%.deb.upload: %.deb .Packages
	$(eval EXISTS := $(shell grep $(notdir $<) .Packages))
	if [ "$(EXISTS)" = "" ]; then package_cloud push psf/infra/ubuntu/trusty $<; fi


upload: $(foreach d, $(AMD64_PKGS), $(firstword $(subst /, , $(d)))/$(firstword $(subst /, , $(d)))_$(lastword $(subst /, , $(d)))_amd64.deb.upload) \
		$(foreach d, $(ALL_PKGS), $(firstword $(subst /, , $(d)))/$(firstword $(subst /, , $(d)))_$(lastword $(subst /, , $(d)))_all.deb.upload)


clean:
	rm -f .Packages
	find . -name '*.deb' -delete
