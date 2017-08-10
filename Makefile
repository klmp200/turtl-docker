all: deps

clean:
	rm -rf dist/*

deps: dist/ccl-1.11-linuxx86.tar.gz dist/quicklisp.lisp dist/cl-hash-util.zip dist/turtl-api.zip dist/s6-overlay-amd64.tar.gz dist/confd-0.12.0-alpha3-linux-amd64

# files to retrieve
dist/quicklisp.lisp:
	wget -O dist/quicklisp.lisp https://beta.quicklisp.org/quicklisp.lisp
	touch $@

dist/turtl-api.zip:
	wget -O dist/turtl-api.zip https://github.com/turtl/api/archive/master.zip
	touch $@

dist/cl-hash-util.zip:
	wget -O dist/cl-hash-util.zip https://github.com/orthecreedence/cl-hash-util/archive/master.zip
	touch $@

dist/ccl-1.11-linuxx86.tar.gz:
	wget -P dist https://ccl.clozure.com/ftp/pub/release/1.11/ccl-1.11-linuxx86.tar.gz
	touch $@

dist/s6-overlay-amd64.tar.gz:
	wget -O dist/s6-overlay-amd64.tar.gz https://github.com/just-containers/s6-overlay/releases/download/v1.19.1.1/s6-overlay-amd64.tar.gz
	touch $@

dist/confd-0.12.0-alpha3-linux-amd64:
	wget -O dist/confd-0.12.0-alpha3-linux-amd64 https://github.com/kelseyhightower/confd/releases/download/v0.12.0-alpha3/confd-0.12.0-alpha3-linux-amd64
	touch $@
