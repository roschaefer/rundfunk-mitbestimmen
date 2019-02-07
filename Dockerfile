FROM rundfunkmitbestimmen/backend

WORKDIR /fullstack

RUN mv /backend ./backend

COPY Gemfile      ./Gemfile
COPY Gemfile.lock ./Gemfile.lock
COPY features     ./features

RUN bundle install

