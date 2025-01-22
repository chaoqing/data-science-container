.DEFAULT_GOAL := build

#* Makefile debugging
print-%: ; @$(warning $* is $($*) ($(value $*)) (from $(origin $*)))

define message
@echo -n "make[top]: "
@echo $(1)
endef

build: generate
	docker build --build-arg ROOT_IMAGE=ubuntu:24.04 -t data-science-container:nightly --target final build/

test:
	@echo "docker build --build-arg ROOT_IMAGE=ubuntu:24.04 -t data-science-container:debug --target debug build/"
	@echo "docker run --rm -it --name test data-science-container:debug"

clean: FORCE
	rm -rf build

generate: clean
	rsync -av src/root build/
	python3 build.py src/ --desktop -o build/Dockerfile

sync-third-party:
	git submodule update
	mkdir -p src/Dockerfile.d/

	bash -c "cat third_party/jupyter/images/{docker-stacks-foundation,base-notebook,minimal-notebook,scipy-notebook,datascience-notebook}/Dockerfile" > src/Dockerfile.d/10-jupyter-base
	cp third_party/rstudio/dockerfiles/ml-verse_4.3.3.Dockerfile src/Dockerfile.d/20-rstudio-base

	mkdir -p src/setup-scripts/install-rstudio.d/
	cp third_party/rstudio/scripts/install_R_source.sh src/setup-scripts/install-rstudio.d/10-install_R_source.sh
	cp third_party/rstudio/scripts/setup_R.sh src/setup-scripts/install-rstudio.d/20-setup_R.sh
	cp third_party/rstudio/scripts/config_R_cuda.sh src/setup-scripts/install-rstudio.d/30-config_R_cuda.sh
	cp third_party/rstudio/scripts/install_tidyverse.sh src/setup-scripts/install-rstudio.d/40-install_tidyverse.sh
	cp third_party/rstudio/scripts/install_rstudio.sh src/setup-scripts/install-rstudio.d/50-install_rstudio.sh
	cp third_party/rstudio/scripts/install_pandoc.sh src/setup-scripts/install-rstudio.d/60-install_pandoc.sh
	cp third_party/rstudio/scripts/install_quarto.sh src/setup-scripts/install-rstudio.d/70-install_quarto.sh
	cp third_party/rstudio/scripts/install_verse.sh src/setup-scripts/install-rstudio.d/80-install_verse.sh
	cp third_party/rstudio/scripts/install_texlive.sh src/setup-scripts/install-rstudio.d/85-install_texlive.sh
	cp third_party/rstudio/scripts/install_geospatial.sh src/setup-scripts/install-rstudio.d/90-install_geospatial.sh
	cp third_party/rstudio/scripts/install_wgrib2.sh src/setup-scripts/install-rstudio.d/92-install_wgrib2.sh
	cp third_party/rstudio/scripts/install_shiny_server.sh src/setup-scripts/install-rstudio.d/95-install_shiny_server.sh

	mkdir -p src/root/etc/skel/.rstudio

	mkdir -p src/root/usr/local/bin/start-notebook.d/
	cp third_party/rstudio/scripts/init_set_env.sh src/root/usr/local/bin/start-notebook.d/30-rstudio-set-envs.sh
	cp third_party/rstudio/scripts/init_userconf.sh src/root/usr/local/bin/start-notebook.d/40-rstudio-userconf.sh
	cp third_party/rstudio/scripts/bin/install2.r src/root/usr/local/bin/install2while_missing.r

	mkdir -p src/setup-scripts/install-desktop.d/
	cp third_party/vnc/src/debian/install/tigervnc.sh src/setup-scripts/install-desktop.d/10-install-vncserver.sh
	cp third_party/vnc/src/common/install/firefox.sh src/setup-scripts/install-desktop.d/50-install-firefox.sh
	cp third_party/vnc/src/common/install/no_vnc.sh src/setup-scripts/install-desktop.d/90-install-noVNC.sh
	
	cp third_party/rstudio/scripts/install_nvtop.sh src/setup-scripts/95-install-nvtop.sh

	mkdir -p src/root/usr/local/bin/
	cp third_party/jupyter/images/docker-stacks-foundation/fix-permissions src/root/usr/local/bin/fix-permissions
	cp third_party/jupyter/images/docker-stacks-foundation/run-hooks.sh src/root/usr/local/bin/run-hooks.sh
	cp third_party/jupyter/images/docker-stacks-foundation/start.sh src/root/usr/local/bin/container_entrypoint.sh
	cp third_party/vnc/src/common/scripts/vnc_startup.sh src/root/usr/local/bin/vnc_startup.sh

	find src/setup-scripts/ -type f -exec chmod +x {} \;
	find src/root/usr/local/bin/ -type f -exec chmod +x {} \;

FORCE:

