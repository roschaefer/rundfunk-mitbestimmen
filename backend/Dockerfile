FROM centos:7

RUN yum -y install openssl-devel
RUN yum -y groupinstall "Development Tools"
RUN yum -y install https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm
RUN yum -y install postgresql96-libs postgresql96-devel
RUN ln -s /usr/pgsql-9.6/bin/pg_config /usr/local/bin/

RUN mkdir ruby
RUN curl -L https://cache.ruby-lang.org/pub/ruby/2.5/ruby-2.5.1.tar.gz | tar xz --strip=1 -C ruby
RUN cd ruby && ./configure && make && make install
RUN rm -R ruby

WORKDIR /backend

RUN gem install bundler
ADD Gemfile /backend/Gemfile
ADD Gemfile.lock /backend/Gemfile.lock
RUN bundle install

ADD . /backend

EXPOSE 3000
