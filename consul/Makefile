deb:
	fpm -s dir -t deb \
		-n $(PACKAGE) -v $(VERSION) \
		-m donald@stufft.io \
		--vendor HashiCorp \
		--url http://www.consul.io \
		--description "Service Discovery and configuration made easy." \
		-a native \
		--deb-default default/consul \
		--deb-upstart init/consul \
		--directories /var/lib/consul \
		--after-install s/postinst \
		--after-remove s/postrm \
		bin/consul=/usr/bin/consul \
		usr/share/consul=/usr/share \
		etc/rsyslog.d/49-consul.conf=/etc/rsyslog.d/49-consul.conf \
		etc/logrotate.d/consul=/etc/logrotate.d/consul
