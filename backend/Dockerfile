FROM centos:6

RUN yum -y install openssl-devel
RUN yum -y groupinstall "Development Tools"
RUN yum -y install https://download.postgresql.org/pub/repos/yum/9.2/redhat/rhel-6-x86_64/pgdg-centos92-9.2-8.noarch.rpm
RUN yum -y install postgresql92-libs postgresql92-devel
RUN ln -s /usr/pgsql-9.2/bin/pg_config /usr/local/bin/
RUN yum clean all

RUN mkdir ruby
RUN curl -L https://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.3.tar.gz | tar xz --strip=1 -C ruby
RUN cd ruby && ./configure && make && make install
RUN rm -R ruby

WORKDIR /backend

RUN gem install bundler -v 1.13.2
ADD Gemfile /backend/Gemfile
ADD Gemfile.lock /backend/Gemfile.lock
RUN bundle install

ADD . /backend

EXPOSE 3000
