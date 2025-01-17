.DEFAULT_GOAL := build

#* Makefile debugging
print-%: ; @$(warning $* is $($*) ($(value $*)) (from $(origin $*)))

define message
@echo -n "make[top]: "
@echo $(1)
endef

build: generate
	docker build --build-arg ROOT_IMAGE=ubuntu:24.04 -t data-science-container --target final build/

test:
	@echo "docker build --build-arg ROOT_IMAGE=ubuntu:24.04 -t data-science-container:debug --target debug --progress=plain build/"
	@echo "docker run --rm -it --name test -u 0 -e GRANT_SUDO=1 --security-opt seccomp=unconfined -p 6901:6901 data-science-container:debug vnc_startup.sh"

clean: FORCE
	rm -rf build

generate: clean
	rsync -av src/root build/
	python3 build.py src/ --desktop -o build/Dockerfile


FORCE:
