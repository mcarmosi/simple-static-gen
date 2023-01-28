MD_FILES := $(shell find pages -type f -name '*.md')
ORG_FILES := $(shell find pages -type f -name '*.org')

STATIC_FILES := $(shell find pages -type f)
STATIC_FILES := $(filter-out $(MD_FILES), $(STATIC_FILES))
STATIC_FILES := $(filter-out $(ORG_FILES), $(STATIC_FILES))

STATIC_TARGETS := $(STATIC_FILES:pages/%=build/%)

MD_TARGETS := $(MD_FILES:pages/%.md=build/%.html)

ORG_TARGETS := $(ORG_FILES:pages/%.org=build/%.html)

# substitution reference has form $(var:a=b)
# shorthand for $(patsubst pattern,replacement,text)

all : $(ORG_TARGETS) $(MD_TARGETS) $(STATIC_TARGETS)

# static pattern rules are deterministic in application

$(MD_TARGETS): build/%.html: pages/%.md
	@mkdir -p $(dir $@)
	pandoc -s -c simple.css -c addenda.css -t html5 --template simple.html5 $< -o $@

$(ORG_TARGETS): build/%.html: pages/%.org
	@mkdir -p $(dir $@)
	pandoc -s -c simple.css -c addenda.css -t html5 --template simple.html5 $< -o $@

$(STATIC_TARGETS): build/%: pages/%
	@mkdir -p $(dir $@)
	cp $< $@

.PHONY: clean
clean:
	rm -rf build/
