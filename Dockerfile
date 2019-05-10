FROM ruby:2.6.3-slim

ENV EXE=bib2csv.rb
ENV BIBTEX=my-work.bib

ADD Gemfile .
RUN bundle install

ADD bib2txt.rb bib2csv.rb bib2csv.csl run.sh /
ENTRYPOINT /run.sh
