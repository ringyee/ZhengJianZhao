ifndef INCLUDE_LIB_PORTRAIT_LINK_MK
INCLUDE_LIB_PORTRAIT_LINK_MK:=1

PORTRAIT_DIR ?= ../..
ifneq ($(PORTRAIT_DIR), $(wildcard $(PORTRAIT_DIR)))
    $(error Cannot find portrait at $(PORTRAIT_DIR), define PORTRAIT_DIR first.)
endif

PORTRAIT_LIBA_DEBUG  := \
  $(PORTRAIT_DIR)/make/common/bin/debug/libportrait.a \
  $(PORTRAIT_DIR)/make/common/obj/debug/src/portrait/haarcascade.cc.o
PORTRAIT_LIBA_RELEASE := \
  $(PORTRAIT_DIR)/make/common/bin/release/libportrait.a \
  $(PORTRAIT_DIR)/make/common/obj/release/src/portrait/haarcascade.cc.o

ifdef debug
  PORTRAIT_LIBA:=$(PORTRAIT_LIBA_DEBUG)
else
  PORTRAIT_LIBA:=$(PORTRAIT_LIBA_RELEASE)
endif

CXXFLAGS     += `pkg-config --cflags opencv` -I$(PORTRAIT_DIR)/include
LIBS         += `pkg-config --libs opencv`
EXT_LNK_OBJS += $(PORTRAIT_LIBA)

#定义all空依赖避免覆盖build.mk中的默认终极目标
all :

PORTRAIT_ALL_SRC:= \
  $(shell find $(PORTRAIT_DIR)/src -name "*") \
  $(shell find $(PORTRAIT_DIR)/include -name "*")

$(PORTRAIT_LIBA_DEBUG) : $(PORTRAIT_ALL_SRC)
	@$(MAKE) -C $(PORTRAIT_DIR)/make/common debug=1
	@touch $@

$(PORTRAIT_LIBA_RELEASE) : $(PORTRAIT_ALL_SRC)
	@$(MAKE) -C $(PORTRAIT_DIR)/make/common
	@touch $@

include $(PORTRAIT_DIR)/make/common/build.mk

endif #ifndef INCLUDE_LIB_PORTRAIT_LINK_MK