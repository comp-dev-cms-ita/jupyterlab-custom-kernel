CONDA_ACTIVATE=source $$(conda info --base)/etc/profile.d/conda.sh ; conda activate ; conda activate
CONDA_DEACTIVATE=source $$(conda info --base)/etc/profile.d/conda.sh ; conda deactivate
CONDA_REMOVE=source $$(conda info --base)/etc/profile.d/conda.sh ; conda remove -y --all -n

ENV_NAME=jupyterlab-custom-kernel

.PHONY: clean build dist env cp

.EXPORT_ALL_VARIABLES:

default: all ## Default target is all.

help: ## display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

all: clean install build dist ## Clean, install and build.

build:
	($(CONDA_ACTIVATE) ${ENV_NAME}; \
		yarn build )

clean:
	rm -fr build || true
	rm -fr dist || true
	rm -fr *.egg-info || true
	rm -fr ksmm/labextension || true
	find . -name '*.egg-info' -exec rm -fr {} + || true
	find . -name '__pycache__' -exec rm -fr {} + || true

env-rm:
	-conda remove -y --all -n ${ENV_NAME}

env:
	-conda env create -f environment.yaml
	@echo 
	@echo --------------------------------
	@echo ✨  ${ENV_NAME} environment is created.
	@echo --------------------------------
	@echo

install-dev:
	($(CONDA_ACTIVATE) ${ENV_NAME}; \
		pip install -e . && \
		jlpm && \
		jlpm build && \
		jupyter labextension develop --overwrite .)

install-kernelspecs:
	($(CONDA_ACTIVATE) ${ENV_NAME}; \
		jupyter kernelspec install ./examples/python-template-1 && \
		jupyter kernelspec list .)

jlab:
	($(CONDA_ACTIVATE) ${ENV_NAME}; \
		jupyter lab \
			--ServerApp.jpserver_extensions="{'jupyterlab-custom-kernel': True}" \
			--no-browser \
			--port 8234)

jlab-watch:
	($(CONDA_ACTIVATE) ${ENV_NAME}; \
		jupyter lab \
			--watch \
			--ServerApp.jpserver_extensions="{'jupyterlab-custom-kernel': True}" \
			--port 8234)

watch:
	($(CONDA_ACTIVATE) ${ENV_NAME}; \
		yarn watch )

main:
	($(CONDA_ACTIVATE) ${ENV_NAME}; \
		python -m jupyterlab_custom_kernel )

build_release:
	($(CONDA_ACTIVATE) ${ENV_NAME}; \
		rm -fr dist/* && \
		jlpm &&\
		yarn clean && \
		jlpm build:prod && \
		python setup.py sdist bdist_wheel && \
		ls -lh  dist/)

publish: build_release
	($(CONDA_ACTIVATE) ${ENV_NAME}; \
		twine upload dist/* )
