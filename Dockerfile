FROM ruby:3.3.5

WORKDIR /home/app

RUN gem install bundler

ENTRYPOINT [ "/bin/bash" ]
