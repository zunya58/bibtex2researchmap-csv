FROM ruby:2.6.3-slim

ENV EXE=bib2csv.rb

ADD Gemfile .
RUN bundle install

ADD bib2txt.rb bib2csv.rb bib2csv.csl run.sh /
ENTRYPOINT /run.sh
