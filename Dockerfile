FROM alpine:latest
MAINTAINER Lars Kiesow <lkiesow@uos.de>

# Install certbot and cloudflare plugin
RUN apk --update add \
   openjdk8-jre-base \
	openssh-client \
   git

# Install Crowdin client
RUN mkdir -p /opt/crowdin
RUN cd /opt/crowdin \
   && wget https://downloads.crowdin.com/cli/v2/crowdin-cli.zip \
   && unzip crowdin-cli.zip \
   && mv */crowdin-cli.jar . \
   && rm -r $(ls | grep -v '\.jar$')

# Add start script
ADD autocrowdin.sh /opt/bin/autocrowdin
RUN chmod 755 /opt/bin/autocrowdin

# Ensure ~/.ssh exists
RUN mkdir ~/.ssh/
RUN chmod 700 ~/.ssh/

CMD ["/opt/bin/autocrowdin"]
