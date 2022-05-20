CA ?= example-ca
CERT ?= example-cert

out/$(CERT).crt: out/$(CERT).csr out/$(CA).crt out/$(CA).key conf/$(CERT).cnf
	openssl x509 -req -in out/$(CERT).csr -CA out/$(CA).crt -CAkey out/$(CA).key -CAcreateserial -out out/$(CERT).crt -days 3650 -sha256 -extfile conf/$(CERT).cnf -extensions req_ext

out/$(CERT).csr: out/$(CERT).key conf/$(CERT).cnf
	openssl req -new -sha256 -key out/$(CERT).key -out out/$(CERT).csr -config conf/$(CERT).cnf

out/$(CERT).key:
	openssl genrsa -out out/$(CERT).key 2048

out/$(CA).crt: out/$(CA).key conf/$(CA).cnf
	openssl req -x509 -new -nodes -key out/$(CA).key -sha256 -days 3560 -out out/$(CA).crt -config conf/$(CA).cnf

out/$(CA).key:
	openssl genrsa -out out/$(CA).key 4096
