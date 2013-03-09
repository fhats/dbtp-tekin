# Tekin

Created by cloning hubot (git://github.com/github/hubot.git) and running:

* `npm install`
* `bin/hubot --create ../path/to/tekin

Requires nodejs and npm to get started:

	sudo apt-get install python-software-properties python g++ make
	sudo add-apt-repository ppa:chris-lea/node.js
	sudo apt-get update
	sudo apt-get install nodejs npm

Other packages to install:
* redis-server

## Scripts

Script files are maintained in the `available-scripts` directory. Scripts are
activated by containing a symlink in `scripts` to a script in
`available-scripts` with the same name. `make scripts` can be used to automate
this process, and will build the `scripts` directory based on the contents of
`installed-scripts`.
