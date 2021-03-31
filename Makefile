
# This list determines chapters order in the actual output
SOURCES_ALL = build/doc.md \
	$(wildcard doc/introduction/*.md) \
	$(wildcard doc/project-security/*.md) \
	$(wildcard doc/user/hardware/*.md) \
	$(wildcard doc/user/downloading-installing-upgrading/*.md) \
	$(wildcard doc/user/downloading-installing-upgrading/upgrade/*.md) \
	$(wildcard doc/user/common-tasks/*.md) \
	$(wildcard doc/user/managing-os/*.md) \
	$(wildcard doc/user/managing-os/*/*.md) \
	$(wildcard doc/user/advanced-configuration/*.md) \
	$(wildcard doc/user/reference/*.md) \
	$(wildcard doc/developer/general/*.md) \
	$(wildcard doc/developer/code/*.md) \
	$(wildcard doc/developer/system/*.md) \
	$(wildcard doc/developer/services/*.md) \
	$(wildcard doc/developer/debugging/*.md) \
	$(wildcard doc/developer/building/*.md) \
	$(null)

EXCLUDE = \
	doc/developer/general/gsoc.md \
	doc/developer/general/gsod.md \
	doc/developer/general/join.md \
	doc/developer/general/package-contributions.md \
	doc/developer/general/style-guide.md \
	doc/introduction/code-of-conduct.md \
	doc/introduction/experts.md \
	doc/project-security/canary-checklist.md \
	doc/project-security/canary-template.md \
	doc/project-security/security-bulletins-checklist.md \
	doc/project-security/security-bulletins-template.md \
	doc/project-security/xsa.md \
	doc/user/downloading-installing-upgrading/upgrade/upgrade-to-r2.md \
	doc/user/downloading-installing-upgrading/upgrade/upgrade-to-r2b1.md \
	doc/user/downloading-installing-upgrading/upgrade/upgrade-to-r2b2.md \
	doc/user/downloading-installing-upgrading/upgrade/upgrade-to-r2b3.md \
	doc/user/downloading-installing-upgrading/upgrade/upgrade-to-r3_0.md \
	doc/user/downloading-installing-upgrading/upgrade/upgrade-to-r3_1.md \
	doc/user/downloading-installing-upgrading/upgrade/upgrade-to-r3_2.md \
	doc/user/hardware/certified-hardware.md \
	doc/user/hardware/hcl_listing.md \
	doc/user/reference/research.md \
	$(null)

SOURCES = $(filter-out $(EXCLUDE), $(SOURCES_ALL))

INTERMEDIATE = $(addprefix build/,$(patsubst %.md,%.json,$(SOURCES)))

all: build/qubes-doc.pdf

build/doc.md: sections.yaml scripts/generate-toc.py
	mkdir -p $(dir $@)
	cd doc; ../scripts/generate-toc.py ../sections.yaml $(patsubst doc/%,%,$(filter-out build/doc.md,$(SOURCES))) > ../$@

$(INTERMEDIATE): build/%.json: %.md scripts/filter-links.py
	mkdir -p $(dir $@)
	pandoc --filter=scripts/filter-links.py $< -o $@

build/qubes-doc.pdf: $(INTERMEDIATE) footer.json
	pandoc --standalone --pdf-engine=xelatex $^ -o $@


install:
	install -m 0644 -D qubes-doc.desktop \
		$(DESTDIR)/usr/share/applications/qubes-doc.desktop
	install -m 0644 -D build/qubes-doc.pdf \
		$(DESTDIR)/usr/share/qubes/qubes-doc.pdf

get-sources:
	git submodule update --init --recursive

verify-sources:
	@true
