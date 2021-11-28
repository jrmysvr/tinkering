
build:
	docker build --tag pypubsub_demo -f Dockerfile .

build_client:
	docker build --tag pypubsub_demo_client -f Dockerfile.client .

run:
	docker run --rm \
		--net host \
		-v $(shell pwd):/demo \
		pypubsub_demo

run_client:
	docker run --rm -it \
		--net host \
		-v $(shell pwd)/client:/demo \
		pypubsub_demo_client
