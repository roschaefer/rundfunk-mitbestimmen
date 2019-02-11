FROM rundfunkmitbestimmen/backend

WORKDIR /fullstack

RUN mv /backend ./backend

COPY Gemfile Gemfile.lock ./
COPY features     .

RUN bundle install

