NODE_PATH = ./node_modules
JS_COMPILER = $(NODE_PATH)/uglify-js/bin/uglifyjs
JS_TESTER = $(NODE_PATH)/vows/bin/vows

all: \
	reorder.v1.js \
	reorder.v1.min.js \
	package.json

reorder.v1.js: \
	src/core.js \
	src/dist.js \
	src/random.js \
	src/permute.js \
	src/leaforder.js

test: all
	@$(JS_TESTER)

%.min.js: %.js Makefile
	@rm -f $@
	$(JS_COMPILER) < $< > $@

%.js:
	@rm -f $@
	@echo '(function(exports){' > $@
	cat $(filter %.js,$^) >> $@
	@echo '})(this);' >> $@
	@chmod a-w $@

install: package.json
	mkdir -p node_modules
	npm install

package.json: src/package.js
	@rm -f $@
	node src/package.js > $@
	@chmod a-w $@

clean:
	rm -f reorder*.js package.json