FROM debian:stretch-slim

RUN mkdir -p /opt/turtl /opt/ccl /opt/quicklisp
COPY dist/* /tmp/

RUN DEBIAN_FRONTEND=noninteractive apt-get update -yqq > /dev/null && \
    apt-get install -yqq --no-install-recommends unzip          \
                                                 libuv1-dev     \
                                                 libssl1.0-dev  \
                                                 libc-dev       \
                                                 gcc            \
                                                 > /dev/null && \
    apt-get -y autoclean

# Install ccl
RUN tar xzf /tmp/ccl-1.11-linuxx86.tar.gz -C /opt/ccl --strip-components=1

# install quicklisp
COPY quicklisp-init.lisp /opt/quicklisp/init.lisp
RUN /opt/ccl/lx86cl64 --load /tmp/quicklisp.lisp < /opt/quicklisp/init.lisp

# install turtl API
RUN cd /opt/turtl && unzip /tmp/turtl-api.zip && mv api-master api
#RUN cd /root/quicklisp/local-projects && unzip /tmp/cl-hash-util.zip
#RUN /opt/ccl/lx86cl64 -l /root/quicklisp/setup.lisp

# config
COPY turtl-requirements.lisp /opt/turtl/api/requirements.lisp
COPY turtl-setup /opt/turtl/setup
COPY turtl-start /opt/turtl/start
COPY turtl-launch.lisp /opt/turtl/api/launch.lisp

COPY etc/ /etc/

# TODO: move to s6 fix perms
RUN chmod a+x /opt/turtl/setup
RUN chmod a+x /opt/turtl/start

# add confd
RUN mv /tmp/confd-0.12.0-alpha3-linux-amd64 /opt/confd && chmod a+x /opt/confd && /opt/confd --onetime --backend env

# finalize setup
RUN /opt/turtl/setup
#> /var/log/turtl-setup.log 2>&1

# add s6
# RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /

# cleaning
RUN rm -rf /tmp/* /var/lib/apt/lists/*

# general settings

# TODO: healtcheck
EXPOSE 8181
WORKDIR /opt/turtl/api
VOLUME /opt/turtl/api

ENTRYPOINT ["/bin/sh"]
CMD ["/opt/turtl/start"]
