QT_BRANCH ?= 6.4
VERSION ?= 0.4.0
CONTAINER_NAME = chpoker-qt-wasm-build

all : wasm

wasm_container :
	podman container exists $(CONTAINER_NAME) || podman create --name $(CONTAINER_NAME) -v "${PWD}:/home/dev/src:ro" qtwebasm:$(QT_BRANCH) bash -lc "mkdir -p build/; cd build/; qmake ../src/; make -j4; tar -cJf chpoker-qt-$(VERSION).tar.xz *.html *.js *.wasm"

wasm : wasm_container
	podman start -a $(CONTAINER_NAME)
	podman cp $(CONTAINER_NAME):/home/dev/build/chpoker-qt-$(VERSION).tar.xz ./

wasm_clean :
	podman rm -f $(CONTAINER_NAME)
	rm chpoker-qt-*.tar.xz

clean : wasm_clean
