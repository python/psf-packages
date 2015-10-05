deb:
	fpm -s dir -t deb \
		-n $(PACKAGE) -v $(VERSION) \
		-m donald@stufft.io \
		--vendor HashiCorp \
		--url https://github.com/hashicorp/consul-template \
		--description "Generic template rendering and notifications with Consul." \
		-a native \
		--deb-default default/consul-template \
		--deb-upstart init/consul-template \
		--after-install s/postinst \
		--after-remove s/postrm \
		bin/consul-template=usr/bin/consul-template \
		etc/rsyslog.d/49-consul-template.conf=/etc/rsyslog.d/49-consul-template.conf \
		etc/logrotate.d/consul-template=/etc/logrotate.d/consul-template
