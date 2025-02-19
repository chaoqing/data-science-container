.DEFAULT_GOAL := build
GENERATE_OPTIONS ?= --desktop xfce4 --analysis
FEATURES_OPTIONS ?=
ifeq ($(FEATURES),full)
	FEATURES_OPTIONS += --analysis
endif
DOCKER ?= DOCKER_BUILDKIT=1 docker

#* Makefile debugging
print-%: ; @$(warning $* is $($*) ($(value $*)) (from $(origin $*)))

define message
@echo -n "make[top]: "
@echo $(1)
endef

build: generate
	$(DOCKER) build --build-arg ROOT_IMAGE=ubuntu:24.04 -t data-science-container --target final build/

test:
	@echo "$(DOCKER) build --build-arg ROOT_IMAGE=ubuntu:24.04 -t data-science-container:debug --target debug --progress=plain build/"
	@echo "$(DOCKER) run --rm -it --name test -u 0 -e GRANT_SUDO=1 -e USER_NAME=$$(id -un) --security-opt seccomp=unconfined -p 6901:6901 -e SKIP_ENTRYPOINT=FALSE data-science-container:debug supervisord --nodaemon -c ~/.local/etc/supervisor/supervisord.conf"

clean: FORCE
	rm -rf build

generate: clean
	rsync -av src/root build/
	rsync -av src/setup-scripts build/
	python3 build.py src/ $(GENERATE_OPTIONS) $(FEATURES_OPTIONS) -o build/Dockerfile

FORCE:

