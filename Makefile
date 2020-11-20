.PHONY: *

build:
	docker build -t helloworld .
run:
	docker run helloworld
