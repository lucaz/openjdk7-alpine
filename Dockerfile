FROM alpine:3.7

RUN apk --update add openjdk7-jre

CMD ["/usr/bin/java", "-version"]