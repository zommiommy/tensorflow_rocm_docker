run:
	make build
	docker run -v "${PWD}/../docker_home_folder:/io" -p 10000:10000 --device=/dev/kfd --device=/dev/dri --group-add video --security-opt seccomp=unconfined -it jupyter-gpu tmux new-session -s "jupyter" python3 -m jupyter notebook --no-browser --allow-root --ip=0.0.0.0 --port=10000

build:
	docker build -t jupyter-gpu -f ./JupyterDocker .
