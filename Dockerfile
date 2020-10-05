FROM ruby:2.7.1

ARG SKYNET_VERSION
COPY pkg/skynet-deploy-$SKYNET_VERSION.gem /
RUN gem install /skynet-deploy-$SKYNET_VERSION.gem

EXPOSE 7575

ARG UID=1000
RUN adduser --home /skynet --uid $UID --disabled-password skynet
USER skynet
RUN mkdir -p /skynet/config
WORKDIR /skynet/config

CMD ["skynet", "server"]
