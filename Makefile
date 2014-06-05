install:
	rm -rf mcrcon
	git clone https://github.com/Tiiffi/mcrcon
	cd mcrcon && gcc -std=gnu99 -pedantic -Wall -Wextra -O2 -s -o mcrcon mcrcon.c
