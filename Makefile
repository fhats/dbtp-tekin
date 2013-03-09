# Provides a means of automating the setup and installation of Tekin

.PHONY: all install scripts

all:
	@echo "To install Tekin, please run \`make install\`!"

install:
	npm install
	sudo ln -sf `pwd`/bin/hubot /usr/bin/tekin
	sudo cp init/tekin.conf /etc/init/tekin.conf

scripts:
	tools/build-scripts installed-scripts scripts available-scripts
