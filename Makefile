#OPTS=--no-cache --rm 
OPTS=

IMAGE=bibtex2researchmap-csv

run:
	docker run -v `pwd`/output:/work -w /work $(IMAGE)

build: Dockerfile
	docker build $(OPTS) -t $(IMAGE) .

clean:
	docker rmi $(IMAGE)

