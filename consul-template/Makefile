VERSION = 0.10.0

deb:
	fpm -s dir -t deb \
		-n consul-template -v $(VERSION) \
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
		etc/consul-template.d=/etc \
		usr/share/consul-template=/usr/share \
		etc/rsyslog.d/49-consul-template.conf=/etc/rsyslog.d/49-consul-template.conf \
		etc/logrotate.d/consul-template=/etc/logrotate.d/consul-template
