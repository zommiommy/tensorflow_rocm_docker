PORT=10000

run:
	make build
	docker run -v "${PWD}/../docker_home_folder:/io" \
		-p ${PORT}:${PORT} --device=/dev/kfd --device=/dev/dri \
		--group-add video --security-opt seccomp=unconfined \
		-it jupyter-gpu tmux new-session -s "jupyter" \
		python3 -m jupyter notebook --no-browser --allow-root --ip=0.0.0.0 --port=${PORT}

build:
	docker build -t jupyter-gpu -f ./JupyterDocker .
