#
###############################################################################
# Copyright 2025-2026, Contributors to the Grid Edge Interoperability &
# Security Alliance (GEISA), a Series of LF Projects, LLC
# This file is licensed under the Community Specification License 1.0
# available at:
# https://github.com/geisa/specification/blob/main/LICENSE.md or
# https://github.com/CommunitySpecification/Community_Specification/blob/main/1._Community_Specification_License-v1.md
###############################################################################
# Makefile for building .binpb files from .proto files using protoc.
###############################################################################
# NOTE: Ubuntu LTS 22.04 will work but needs the --experimental_allow_proto3_optional 
# flag to be added to the protoc command, which is not advertised by the protoc 
# version that comes with Ubuntu 22.04 but is supported.  The Makefile will 
# check the protoc version and adds the flag if needed.
###############################################################################

PROTOS ?= $(wildcard *.proto)

BUILDDIR = build
BINPBS = $(patsubst %.proto,$(BUILDDIR)/%.binpb,$(PROTOS))

PROTOC ?= protoc

# Check if the installed protoc version supports the --experimental_allow_proto3_optional 
# flag, which is required for proto3 optional fields.  At least Ubuntu 22.xx LTS supports
# the flag but doesn't advertise it so need to do a version check instead..
PROTOC_VERSION := $(shell $(PROTOC) --version | awk '{print $$2}')

PROTOC_FLAGS ?=
ifeq ($(shell printf "3.12.0\n$(PROTOC_VERSION)\n" | sort -V | head -n1),3.12.0)
  ifneq ($(shell printf "$(PROTOC_VERSION)\n3.15.0\n" | sort -V | head -n1),3.15.0)
    PROTOC_FLAGS += --experimental_allow_proto3_optional
  endif
endif

all: $(BINPBS)

$(BUILDDIR)/%.binpb: %.proto
	@mkdir -p $(@D)
	$(PROTOC) $(PROTOC_FLAGS) -o $@ $<

clean:
	rm -rf $(BUILDDIR)
