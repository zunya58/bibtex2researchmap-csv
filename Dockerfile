FROM ruby:2.6.3-slim

# original: https://github.com/nbhr/bibtex2researchmap-csv
ENV SRC=scripts
ENV EXE=bib2csv.rb
ENV BIBTEX=my-work.bib

ADD Gemfile .
RUN bundle install

ADD $SRC /scripts
ENTRYPOINT /scripts/run.sh
