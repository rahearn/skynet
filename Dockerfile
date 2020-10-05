FROM ruby:2.7.1

ARG UID=1000
RUN adduser --home /skynet --uid $UID --disabled-password skynet
WORKDIR /skynet

ARG SKYNET_VERSION
COPY pkg/skynet-deploy-$SKYNET_VERSION.gem /
RUN gem install /skynet-deploy-$SKYNET_VERSION.gem

EXPOSE 7575

USER skynet

CMD ["skynet", "server"]
