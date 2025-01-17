COBC_FLAGS=-O -A '-include fcgiapp.h'
LD_FLAGS=-lfcgi

all: echo

echo: src/echo.cbl
	cobc $(COBC_FLAGS) -x src/echo.cbl -o bin/echo $(LD_FLAGS)

install: echo
	sudo cp bin/echo /var/www/fcgi-bin/

.PHONY: all install
