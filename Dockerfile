FROM debian:stretch
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -q --fix-missing && \
  apt-get -y upgrade && \
  apt-get -qy install --no-install-recommends \
  									dialog \
  									apt-utils \
  									vdr \
  									vdr-plugin-live \
  									vdr-plugin-vnsiserver \
  									vdr-plugin-streamdev-server \
  									vdr-plugin-epgsearch \
  									vdr-plugin-femon \
  									w-scan \
									locales \
									locales-all


# set locales to english

ENV LC_ALL "en.UTF-8"
ENV LANG "en.UTF-8"
ENV LANGUAGE "en.UTF-8"
ENV DEBIAN_FRONTEND dialog

# initialize with default data

RUN echo "0.0.0.0/0" >> /etc/vdr/plugins/streamdevhosts.conf
RUN echo "0.0.0.0/0" >> /etc/vdr/svdrphosts.conf

# fix some screwed up naming conventions

RUN ln -s /etc/vdr/plugins/vnsi-server /etc/vdr/plugins/vnsiserver
RUN ln -s /var/lib/vdr/plugins/vnsi-server /var/lib/vdr/plugins/vnsiserver

# create the mount for the video recordings

RUN mkdir /video

# initialize with preset config files

ADD target/setup.conf /etc/vdr/setup.conf
#ADD target/channels.conf.terr /var/lib/vdr/channels.conf
ADD target/channels.conf.sat /var/lib/vdr/channels.conf
ADD target/diseqc.conf /etc/vdr/diseqc.conf

# runtime and port exposes

EXPOSE 8008 37890 6419 3000 34890 2270
CMD /usr/bin/vdr --port=6419 -Plive -Pstreamdev-server  -Pvnsiserver -P epgsearch -Pfemon  -v /video
