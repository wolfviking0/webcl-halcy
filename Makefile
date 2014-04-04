#
#  Makefile
#  Licence : https://github.com/wolfviking0/webcl-translator/blob/master/LICENSE
#
#  Created by Anthony Liot.
#  Copyright (c) 2013 Anthony Liot. All rights reserved.
#

# Default parameter
DEB = 0
VAL = 0
NAT = 0
ORIG= 0
FAST= 1

# Chdir function
CHDIR_SHELL := $(SHELL)
define chdir
   $(eval _D=$(firstword $(1) $(@D)))
   $(info $(MAKE): cd $(_D)) $(eval SHELL = cd $(_D); $(CHDIR_SHELL))
endef

# Current Folder
CURRENT_ROOT:=$(PWD)

# Emscripten Folder
EMSCRIPTEN_ROOT:=$(CURRENT_ROOT)/../webcl-translator/emscripten

# Native build
ifeq ($(NAT),1)
$(info ************ NATIVE : NO DEPENDENCIES  ************)

CXX = clang++
CC  = clang

BUILD_FOLDER = $(CURRENT_ROOT)/bin/
EXTENSION = .out

ifeq ($(DEB),1)
$(info ************ NATIVE : DEBUG = 1        ************)

CFLAGS = -O0 -framework OpenCL -framework OpenGL -framework GLUT -framework CoreFoundation -framework AppKit -framework IOKit -framework CoreVideo -framework CoreGraphics

else
$(info ************ NATIVE : DEBUG = 0        ************)

CFLAGS = -O2 -framework OpenCL -framework OpenGL -framework GLUT -framework CoreFoundation -framework AppKit -framework IOKit -framework CoreVideo -framework CoreGraphics

endif

# Emscripten build
else
ifeq ($(ORIG),1)
$(info ************ EMSCRIPTEN : SUBMODULE     = 0 ************)

EMSCRIPTEN_ROOT:=$(CURRENT_ROOT)/../emscripten
else
$(info ************ EMSCRIPTEN : SUBMODULE     = 1 ************)
endif

CXX = $(EMSCRIPTEN_ROOT)/em++
CC  = $(EMSCRIPTEN_ROOT)/emcc

BUILD_FOLDER = $(CURRENT_ROOT)/js/
EXTENSION = .js
GLOBAL =

ifeq ($(DEB),1)
$(info ************ EMSCRIPTEN : DEBUG         = 1 ************)

GLOBAL += EMCC_DEBUG=1

CFLAGS = -s OPT_LEVEL=1 -s DEBUG_LEVEL=1 -s CL_PRINT_TRACE=1 -s WARN_ON_UNDEFINED_SYMBOLS=1 -s CL_DEBUG=1 -s CL_GRAB_TRACE=1 -s CL_CHECK_VALID_OBJECT=1
else
$(info ************ EMSCRIPTEN : DEBUG         = 0 ************)

CFLAGS = -s OPT_LEVEL=3 -s DEBUG_LEVEL=0 -s CL_PRINT_TRACE=0 -s DISABLE_EXCEPTION_CATCHING=0 -s WARN_ON_UNDEFINED_SYMBOLS=1 -s CL_DEBUG=0 -s CL_GRAB_TRACE=0 -s CL_CHECK_VALID_OBJECT=0
endif

ifeq ($(VAL),1)
$(info ************ EMSCRIPTEN : VALIDATOR     = 1 ************)

PREFIX = val_

CFLAGS += -s CL_VALIDATOR=1
else
$(info ************ EMSCRIPTEN : VALIDATOR     = 0 ************)
endif

ifeq ($(FAST),1)
$(info ************ EMSCRIPTEN : FAST_COMPILER = 1 ************)

GLOBAL += EMCC_FAST_COMPILER=1
else
$(info ************ EMSCRIPTEN : FAST_COMPILER = 0 ************)
endif

endif

SOURCES_openclpt		=	clgl.cpp filter.cpp glhelpers.cpp glmain.cpp obj_loader.cpp speedup_grid.cpp Vector.cpp
SOURCES_simpleflow		=	clgl.cpp glhelpers.cpp glmain.cpp pgmloader.cpp Vector.cpp 

INCLUDES_openclpt		=	-I./
INCLUDES_simpleflow		=	-I./

ifeq ($(NAT),0)

KERNEL_openclpt			= 	--preload-file camera_complex.cam --preload-file camera_null.cam --preload-file camera.cam --preload-file tracer.cl --preload-file simple.frag --preload-file quad.vert --preload-file kitbox.obj --preload-file matlib.mat --preload-file smallbox.obj 
KERNEL_simpleflow		= 	--preload-file grand_canyon.pgm --preload-file sand.tga --preload-file skymap_b.tga --preload-file stone.tga --preload-file texture.tga --preload-file particleSimulation.cl --preload-file compose.frag --preload-file curvatureflow.frag --preload-file liquidshade.frag --preload-file particledepth.frag --preload-file particlethickness.frag --preload-file particlevelocity.frag --preload-file simple.frag --preload-file particles.vert --preload-file quad.vert --preload-file simple.vert 

CFLAGS_openclpt			=	-s GL_FFP_ONLY=1 -s LEGACY_GL_EMULATION=1
CFLAGS_simpleflow		=	-s GL_FFP_ONLY=1 -s LEGACY_GL_EMULATION=1

VALPARAM_openclpt		=	-s CL_VAL_PARAM='[""]'
VALPARAM_simpleflow		=	-s CL_VAL_PARAM='[""]'

else

COPY_openclpt			= 	cp camera_complex.cam $(BUILD_FOLDER) && cp camera_null.cam $(BUILD_FOLDER) && cp camera.cam $(BUILD_FOLDER) && cp tracer.cl $(BUILD_FOLDER) && cp simple.frag $(BUILD_FOLDER) && cp quad.vert $(BUILD_FOLDER) && cp kitbox.obj $(BUILD_FOLDER) && cp matlib.mat $(BUILD_FOLDER) && cp smallbox.obj $(BUILD_FOLDER) && 
COPY_simpleflow			= 	cp grand_canyon.pgm $(BUILD_FOLDER) && cp sand.tga $(BUILD_FOLDER) && cp skymap_b.tga $(BUILD_FOLDER) && cp stone.tga $(BUILD_FOLDER) && cp texture.tga $(BUILD_FOLDER) && cp particleSimulation.cl $(BUILD_FOLDER) && cp compose.frag $(BUILD_FOLDER) && cp curvatureflow.frag $(BUILD_FOLDER) && cp liquidshade.frag $(BUILD_FOLDER) && cp particledepth.frag $(BUILD_FOLDER) && cp particlethickness.frag $(BUILD_FOLDER) && cp particlevelocity.frag $(BUILD_FOLDER) && cp simple.frag $(BUILD_FOLDER) && cp particles.vert $(BUILD_FOLDER) && cp quad.vert $(BUILD_FOLDER) && cp simple.vert $(BUILD_FOLDER) && 

endif

.PHONY:    
	all clean

all: \
	all_1 all_2 all_3

all_1: \
	openclpt_sample simpleflow_sample

all_2: \
	

all_3: \


# Create build folder is necessary))
mkdir:
	mkdir -p $(BUILD_FOLDER);

openclpt_sample: mkdir
	$(call chdir,openclpt/openclpt/)
	$(COPY_openclpt) 	$(GLOBAL) $(CXX) $(CFLAGS) $(CFLAGS_openclpt)	$(INCLUDES_openclpt)	$(SOURCES_openclpt)		$(VALPARAM_openclpt) 	$(KERNEL_openclpt) 		-o $(BUILD_FOLDER)$(PREFIX)openclpt$(EXTENSION) 

simpleflow_sample: mkdir
	$(call chdir,simpleflow/WaterSim2/)
	$(COPY_simpleflow) 	$(GLOBAL) $(CXX) $(CFLAGS) $(CFLAGS_simpleflow)	$(INCLUDES_simpleflow)	$(SOURCES_simpleflow)	$(VALPARAM_simpleflow) 	$(KERNEL_simpleflow) 	-o $(BUILD_FOLDER)$(PREFIX)simpleflow$(EXTENSION) 

clean:
	rm -rf bin/
	mkdir -p bin/
	mkdir -p tmp/
	cp js/memoryprofiler.js tmp/ && cp js/settings.js tmp/ && cp js/index.html tmp/
	rm -rf js/
	mkdir js/
	cp tmp/memoryprofiler.js js/ && cp tmp/settings.js js/ && cp tmp/index.html js/
	rm -rf tmp/
	$(EMSCRIPTEN_ROOT)/emcc --clear-cache

	
	
