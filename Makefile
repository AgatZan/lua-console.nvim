.PHONY: api_documentation llscheck luacheck stylua test

api_documentation:
	nvim -u scripts/make_api_documentation/minimal_init.lua -l scripts/make_api_documentation/main.lua

llscheck:
	llscheck --configpath .luarc.json .

luacheck:
	luacheck lua spec # plugin scripts

stylua:
	stylua lua plugin scripts spec

test:
	eval $(luarocks path --lua-version 5.1 --bin)
	busted --run unit

watch:
	while sleep 0.1; do ls -d spec/**/*.lua | entr -d -c make test; done
