# dwm-mk - dynamic window manager
# See LICENSE file for copyright and license details.

include config.mk

SRC = dwm-mk.c
OBJ = ${SRC:.c=.o}

all: options dwm-mk

options:
	@echo dwm-mk build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	@echo CC $<
	@${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk

config.h:
	@echo creating $@ from config.def.h
	@cp config.def.h $@

dwm-mk: ${OBJ}
	@echo CC -o $@
	@${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	@echo cleaning
	@rm -f dwm-mk ${OBJ} dwm-mk-${VERSION}.tar.gz

dist: clean
	@echo creating dist tarball
	@mkdir -p dwm-mk-${VERSION}
	@cp -R LICENSE Makefile README config.def.h config.mk \
		dwm-mk.1 ${SRC} dwm-mk-${VERSION}
	@tar -cf dwm-mk-${VERSION}.tar dwm-mk-${VERSION}
	@gzip dwm-mk-${VERSION}.tar
	@rm -rf dwm-mk-${VERSION}

install: all
	@echo installing executable file to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f dwm-mk ${DESTDIR}${PREFIX}/bin
	@chmod 755 ${DESTDIR}${PREFIX}/bin/dwm-mk
	@echo installing manual page to ${DESTDIR}${MANPREFIX}/man1
	@mkdir -p ${DESTDIR}${MANPREFIX}/man1
	@sed "s/VERSION/${VERSION}/g" < dwm-mk.1 > ${DESTDIR}${MANPREFIX}/man1/dwm-mk.1
	@chmod 644 ${DESTDIR}${MANPREFIX}/man1/dwm-mk.1

uninstall:
	@echo removing executable file from ${DESTDIR}${PREFIX}/bin
	@rm -f ${DESTDIR}${PREFIX}/bin/dwm-mk
	@echo removing manual page from ${DESTDIR}${MANPREFIX}/man1
	@rm -f ${DESTDIR}${MANPREFIX}/man1/dwm-mk.1

.PHONY: all options clean dist install uninstall
