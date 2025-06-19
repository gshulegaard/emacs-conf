VERSION != cut -d "-" -f1 package/version
BUILD_NUM != cut -d "-" -f2 package/version
NEW_BUILD_NUM != expr $(BUILD_NUM) + 1
FILES = src/custom/ src/*.el package/requirements.txt package/version

.PHONY: clean build release dev-rm dev-build dev install

clean:
	@printf "\033[33m Cleaning ...\033[0m"
	@rm -rf build/*
	@rm -f *~
	@rm -f **/*~
	@printf "\033[32m done.\033[0m\n"

build: clean
	@printf "\n\033[33m Starting build ...\033[0m\n"
	@printf "\033[33m Incrementing build number ...\033[0m"
	@sed -i.bak "s/-$(BUILD_NUM)/-$(NEW_BUILD_NUM)/" package/version && rm package/version.bak
	@printf "\033[32m done.\033[0m\n"
	@$(eval FULL_VERSION := "$$VERSION-$$NEW_BUILD_NUM")
	@printf "\033[33m Commit build $(FULL_VERSION) ...\033[0m"
	@git commit -a -m "Build $(FULL_VERSION)" > /dev/null 2>&1
	@git push > /dev/null 2>&1
	@printf "\033[32m done.\033[0m\n"
	@printf "\033[33m Creating build/emacs-conf-$(FULL_VERSION).tar.gz ...\033[0m"
	@tar -czvf build/emacs-conf-$(FULL_VERSION).tar.gz $(FILES) --owner=0 --group=0 > /dev/null 2>&1
	@printf "\033[32m done.\033[0m\n"
	@printf "\033[33m Copying build/emacs-conf-$(FULL_VERSION).tar.gz to release/emacs-conf-$(VERSION).tar.gz ...\033[0m"
	@cp build/emacs-conf-$(FULL_VERSION).tar.gz release/emacs-conf-$(VERSION).tar.gz > /dev/null 2>&1
	@printf "\033[32m done.\033[0m\n"
	@printf "\033[32m Build complete.\033[0m\n"

release:
	@printf "\n\033[33m Release start ...\033[0m\n"
	@printf "\033[33m Git add package release/emacs-conf-$(VERSION).tar.gz ...\033[0m"
	@git add -f release/emacs-conf-$(VERSION).tar.gz > /dev/null 2>&1
	@printf "\033[32m done.\033[0m\n"
	@printf "\033[33m Update package/install.sh ...\033[0m"
	@sed -i "s/VERSION=\".*\"/VERSION=\"$(VERSION)\"/" package/install.sh >	/dev/null 2>&1
	@printf "\033[32m done.\033[0m\n"
	@printf "\033[33m Remove old releases ...\033[0m"
	@ls -t release/* | awk 'NR>3' | xargs rm -f
	@printf "\033[32m done.\033[0m\n"
	@printf "\033[33m Commit and push release $(VERSION) ...\033[0m"
	@git commit -a -m "Release $(VERSION)" > /dev/null 2>&1
	@git push > /dev/null 2>&1
	@printf "\033[32m done.\033[0m\n"
	@printf "\033[33m Tag and push v$(VERSION) ...\033[0m"
	@git tag -a v$(VERSION) -m "Release $(VERSION)" > /dev/null 2>&1
	@git push origin v$(VERSION) > /dev/null 2>&1
	@printf "\033[32m done.\033[0m\n"
	@printf "\033[32m Release finished.\033[0m\n"

dev-rm:
	@cd docker && docker-compose -f dev.compose.yaml rm -s -v -f;

dev-build: dev-rm
	@cd docker && docker-compose -f dev.compose.yaml build --no-cache;

dev:
	@cd docker && docker-compose -f dev.compose.yaml run dev;

install:
	@mkdir -p ~/.emacs.d && cp -r src/* ~/.emacs.d;
