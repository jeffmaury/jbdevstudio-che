#FROM registry.access.redhat.com/ubi8/ubi-minimal:8.2-345
FROM fedora:32
RUN dnf -y update && dnf -y install \
      dbus dbus-daemon dbus-glib \
      xorg-x11-server-utils \
      webkit2gtk3 webkit2gtk3-devel \
      mesa-libGL \
      adobe-source-code-pro-fonts abattis-cantarell-fonts \
      gnome-settings-daemon \
      wget tar \
      java-1.8.0-openjdk \
      && dnf clean all

ENV LD_LIBRARY_PATH=/opt/gtk/lib
ENV PATH="/opt/gtk/bin:$PATH"

# Configure broadway
ENV BROADWAY_DISPLAY=:5
ENV BROADWAY_PORT=5000
EXPOSE 5000
ENV GDK_BACKEND=broadway

# Get Eclipse IDE
RUN echo "Downloading Eclipse" && \
    cd /root && \
    wget -O- "https://ftp.osuosl.org/pub/eclipse/technology/epp/downloads/release/2020-06/R/eclipse-java-2020-06-R-linux-gtk-x86_64.tar.gz" | tar xz && \
    cd eclipse/ 	  

RUN mkdir /projects

RUN for f in "/etc" "/var/run" "/projects" "/root"; do \
    	chgrp -R 0 ${f} && \
    	chmod -R g+rwX ${f}; \
    done

COPY .fonts.conf /root/
COPY .fonts.conf /	 

COPY ./init.sh /
ENTRYPOINT [ "/init.sh" ] 