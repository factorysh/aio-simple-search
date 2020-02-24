PYTHON_VERSION = $(shell python3 -V | cut -d ' ' -f 2 - | cut -d '.' -f 1,2 -)


install: venv/lib/python${PYTHON_VERSION}/site-packages/asonic/__init__.py

venv/bin/python:
	python3 -m venv venv
	venv/bin/pip install -U pip wheel

venv/lib/python${PYTHON_VERSION}/site-packages/asonic/__init__.py: venv/bin/python
	venv/bin/pip install .[tests]

build:
	docker build -t bearstech/sonic .

sonic:
	mkdir -p data/store
	docker-compose up -d

down:
	docker-compose down

ps:
	docker-compose ps

test: build install
	make down
	rm -rf data
	make sonic
	venv/bin/pytest --cov=sonic_rest

clean:
	rm -rf data venv
