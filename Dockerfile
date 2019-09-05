# elementary docker image for vala-lint

FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /opt/vala-lint-portable

COPY . /opt/vala-lint

RUN apt update \
  && apt install -y libvala-dev valac meson

RUN cd /opt/vala-lint \
  && meson build --prefix=/usr \
  && cd build \
  && ninja \
  && DESTDIR=/opt/vala-lint-portable ninja install

FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

COPY --from=0 /opt/vala-lint-portable /

RUN apt update \
  && apt install -y libvala-dev gio-2.0

RUN mkdir -p /app
VOLUME /app
WORKDIR /app

CMD ["/usr/bin/io.elementary.vala-lint", "**/*.vala"]