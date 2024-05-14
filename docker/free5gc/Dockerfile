#FROM bitnami/golang:1.14.4 AS builder
FROM golang:1.21.10-bullseye AS builder

ARG NF FREE5GC_VER

# Control-plane Supporting Packages
RUN apt-get update
RUN apt-get -y install wget git sudo

# Get Free5GC source code
WORKDIR $GOPATH/src
RUN git clone -b ${FREE5GC_VER} -j `nproc` https://github.com/free5gc/free5gc.git && \
    cd free5gc && \
    git submodule update --init NFs/${NF}

RUN if [ "$NF" = "chf" ] ; then sed -i 's/RegisterIPv4/BindingIPv4/g' $GOPATH/src/free5gc/NFs/chf/internal/cgf/cgf.go ; fi

# Build NF
WORKDIR $GOPATH/src/free5gc
RUN make ${NF}

# Build the final image
FROM alpine

ARG NF

RUN if [[ "$NF" = "upf"]] ; then apk --no-cache add iproute2 iptables ; fi

WORKDIR /free5gc

RUN mkdir -p config/ cert/ public

# Copy executables
COPY --from=builder /go/src/free5gc/bin/${NF} ./

# for check
COPY --from=builder /go/src/free5gc/NFs/chf/internal/cgf/cgf.go ./

# Copy certificates and config files
COPY --from=builder /go/src/free5gc/config/${NF}cfg.yaml ./config/
COPY --from=builder /go/src/free5gc/cert/${NF}* ./cert/

WORKDIR /free5gc/

