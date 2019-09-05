# elementary docker image for vala-lint

FROM debian:stable-slim

LABEL Blake Kostner <blake@elementary.io>

COPY . /var/opt/vala-lint

WORKDIR /var/opt/vala-lint

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y libvala-dev valac meson

RUN meson build --prefix=/usr && cd build && ninja && ninja install

RUN mkdir -p /var/opt/vala-lint

VOLUME /var/opt/vala-lint

CMD ["/usr/bin/io.elementary.vala-lint", "**/*.vala"]
