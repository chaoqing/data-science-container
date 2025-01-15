build: generate
	docker build --build-arg ROOT_IMAGE=ubuntu:24.04 -t data-science-container:nightly build/

test:
	echo "I will run test here!"

clean: FORCE
	rm -rf build

generate: clean
	rsync -av src/ build/

sync-third-party:
	git submodule update

	cp third_party/jupyter/images/docker-stacks-foundation/Dockerfile src/Dockerfile.d/10-jupyter-base
	cp third_party/rstudio/dockerfiles/ml-verse_4.3.3.Dockerfile src/Dockerfile.d/20-rstudio-base

	cp third_party/rstudio/scripts/install_R_source.sh src/root/opt/setup-scripts/install-rstudio.d/10-install_R_source.sh
	cp third_party/rstudio/scripts/setup_R.sh src/root/opt/setup-scripts/install-rstudio.d/20-setup_R.sh
	cp third_party/rstudio/scripts/config_R_cuda.sh src/root/opt/setup-scripts/install-rstudio.d/30-config_R_cuda.sh
	cp third_party/rstudio/scripts/install_tidyverse.sh src/root/opt/setup-scripts/install-rstudio.d/40-install_tidyverse.sh
	cp third_party/rstudio/scripts/install_rstudio.sh src/root/opt/setup-scripts/install-rstudio.d/50-install_rstudio.sh
	cp third_party/rstudio/scripts/install_pandoc.sh src/root/opt/setup-scripts/install-rstudio.d/60-install_pandoc.sh
	cp third_party/rstudio/scripts/install_quarto.sh src/root/opt/setup-scripts/install-rstudio.d/70-install_quarto.sh
	cp third_party/rstudio/scripts/install_verse.sh src/root/opt/setup-scripts/install-rstudio.d/80-install_verse.sh
	cp third_party/rstudio/scripts/install_geospatial.sh src/root/opt/setup-scripts/install-rstudio.d/90-install_geospatial.sh
	cp third_party/rstudio/scripts/install_shiny_server.sh src/root/opt/setup-scripts/install-rstudio.d/95-install_shiny_server.sh

	cp third_party/vnc/src/debian/install/tigervnc.sh src/root/opt/setup-scripts/82-install-vncserver.sh
	cp third_party/vnc/src/common/install/firefox.sh src/root/opt/setup-scripts/85-install-firefox.sh
	cp third_party/vnc/src/common/install/no_vnc.sh src/root/opt/setup-scripts/87-install-noVNC.sh
	cp third_party/rstudio/scripts/install_nvtop.sh src/root/opt/setup-scripts/95-install-nvtop.sh

	cp third_party/jupyter/images/docker-stacks-foundation/fix-permissions src/root/usr/local/bin/
	cp third_party/jupyter/images/docker-stacks-foundation/run-hooks.sh src/root/usr/local/bin/
	cp third_party/jupyter/images/docker-stacks-foundation/start.sh src/root/usr/local/bin/
	cp third_party/vnc/src/common/scripts/vnc_startup.sh src/root/usr/local/bin/

	chmod +x src/root/opt/setup-scripts/*
	chmod +x src/root/usr/local/bin/*

FORCE: