#OPTS=--no-cache --rm 
OPTS=

IMAGE=bibtex2researchmap-csv
WORK_DIR=work

run:
	docker run -v `pwd`/$(WORK_DIR):/$(WORK_DIR) -w /$(WORK_DIR) $(IMAGE)

build: Dockerfile Gemfile bib2txt.rb bib2csv.rb bib2csv.csl run.sh
	docker build $(OPTS) -t $(IMAGE) .

clean:
	docker rmi $(IMAGE)

