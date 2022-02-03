FROM mjethanandani/build-yang:latest

RUN mkdir -p /git/ietf-tcp/draft/ /git/ietf-tcp/src/ /git/ietf-tcp/src/yang /git/ietf-tcp/src/dependencies

ADD .git/ /git/ietf-tcp/
ADD src/validate-and-gen-trees.sh /git/ietf-tcp/src
ADD src/addstyle.sed /git/ietf-tcp/src
ADD src/insert-figures.sh /git/ietf-tcp/src
ADD src/dependencies /git/ietf-tcp/src/dependencies/
ADD src/yang/*.yang /git/ietf-tcp/src/yang/
ADD src/yang/example* /git/ietf-tcp/src/yang/
ADD draft/Makefile /git/ietf-tcp/draft/
ADD draft/draft-ietf-tcpm-yang-tcp.xml /git/ietf-tcp/draft/
ADD start.sh /

CMD ["./start.sh"]
