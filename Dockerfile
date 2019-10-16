FROM alpine:3.7
ARG DIST

ENV SBT_VERSION 0.13.17
ENV SBT_HOME /usr/local/sbt
ENV PATH ${PATH}:${SBT_HOME}/bin

RUN apk --update add openjdk7-jre
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
            --repository http://dl-cdn.alpinelinux.org/alpine/edge/main

RUN apk add --update --no-cache \
        curl libgcc libstdc++ libx11 glib libxrender libxext libintl \
        libcrypto1.0 libssl1.0 \
        ttf-dejavu ttf-droid ttf-freefont ttf-liberation ttf-ubuntu-font-family
# Install sbt
RUN apk add --no-cache --update git bash && \
    curl -sL "https://github.com/sbt/sbt/releases/download/v$SBT_VERSION/sbt-$SBT_VERSION.tgz" | gunzip | tar -x -C /usr/local --strip-components=1 && \
    echo -ne "- with sbt $SBT_VERSION\n" >> /root/.built
# Install python3
RUN echo "**** install Python ****" && \
    apk add --no-cache python3 && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    \
    echo "**** install pip ****" && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi
# Install awscli
RUN pip3 install awscli
RUN apk add docker
RUN pip install 'docker-compose==1.8.0'


CMD ["/usr/bin/java", "-version"]
