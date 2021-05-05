# elementary docker image for vala-lint

FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /opt/vala-lint-portable

COPY . /opt/vala-lint

RUN apt-get update \
  && apt-get install -y --no-install-recommends gcc libvala-dev valac meson\
  && cd /opt/vala-lint \
  && meson build --prefix=/usr \
  && cd build \
  && ninja \
  && DESTDIR=/opt/vala-lint-portable ninja install

FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

COPY --from=0 /opt/vala-lint-portable /

RUN apt-get update \
  && apt-get install -y --no-install-recommends libvala-dev gio-2.0 \
  && mkdir -p /app \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

VOLUME /app
WORKDIR /app

CMD ["/usr/bin/io.elementary.vala-lint"]
