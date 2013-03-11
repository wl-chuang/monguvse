# Copyright (c) 2013, William W.L. Chuang
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of Pyraemon Studio nor the
#       names of its contributors may be used to endorse or promote products
#       derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

CFLAGS += -Wall
CFLAGS += -D_GNU_SOURCE=1 -D_REENTRANT
CFLAGS += -Ilibuv-0.9/source/include

LDFLAGS += -Loutput
LDFLAGS += -luv

SOURCE_DIR = src
SOURCE_LIST := $(shell ls -I *.o -I *.h -I *.bak $(SOURCE_DIR))
#SOURCE_LIST := $(shell ls $(SOURCE_DIR)/*.c)
SOURCE_FILES := $(SOURCE_LIST:%.c=$(SOURCE_DIR)/%.c)
OBJECT_FILES := $(SOURCE_FILES:%.c=%.o)
HEADER_FILES := $(shell ls $(SOURCE_DIR)/*.h)

TARGET := monguvse


all: output lib-uv $(TARGET) install

output:
	@if [ ! -d "output" ]; then mkdir output; fi

output-clean:
	rm -rf output

lib-uv: output
	make -C libuv-0.9/source
	cp libuv-0.9/source/libuv.so output

lib-uv-clean:
	make -C libuv-0.9/source clean

install:

#	mkdir -p $(STAGING_BASE)/usr/bin
#	install -m 755 $(TARGET) $(STAGING_BASE)/usr/bin
#	mkdir -p $(STAGING_BASE)/etc/init.d/camera
#	install -m 755 resources/S10wdoggy $(STAGING_BASE)/etc/init.d/camera

$(TARGET): $(OBJECT_FILES)
	$(CC) -o output/$(TARGET) $^ $(LDFLAGS)
	cp start-monguvse.sh output

$(SOURCE_DIR)/%.o: $(HEADER_FILES) $(SOURCE_DIR)/%.c

clean: lib-uv-clean output-clean
	-rm -f $(SOURCE_DIR)/*.o
	-rm -f $(TARGET)

.PHONY: output output-clean \
		lib-uv lib-uv-clean \
		all install clean
