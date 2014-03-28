#
#  Makefile
#  Licence : https://github.com/wolfviking0/webcl-translator/blob/master/LICENSE
#
#  Created by Anthony Liot.
#  Copyright (c) 2013 Anthony Liot. All rights reserved.
#

CURRENT_ROOT:=$(PWD)/

ORIG=0
ifeq ($(ORIG),1)
EMSCRIPTEN_ROOT:=$(CURRENT_ROOT)../emscripten
else

$(info )
$(info )
$(info **************************************************************)
$(info **************************************************************)
$(info ************ /!\ BUILD USE SUBMODULE CARREFUL /!\ ************)
$(info **************************************************************)
$(info **************************************************************)
$(info )
$(info )

EMSCRIPTEN_ROOT:=$(CURRENT_ROOT)../webcl-translator/emscripten
endif

CXX = $(EMSCRIPTEN_ROOT)/em++

CHDIR_SHELL := $(SHELL)
define chdir
   $(eval _D=$(firstword $(1) $(@D)))
   $(info $(MAKE): cd $(_D)) $(eval SHELL = cd $(_D); $(CHDIR_SHELL))
endef

DEB=0
VAL=0
NAT=0
FAST=1

ifeq ($(VAL),1)
PREFIX = val_
VALIDATOR = '[""]' # Enable validator without parameter
$(info ************  Mode VALIDATOR : Enabled ************)
else
PREFIX = 
VALIDATOR = '[]' # disable validator
$(info ************  Mode VALIDATOR : Disabled ************)
endif

ifeq ($(NAT),1)
EXTENSION = out
DEBUG = -O0 -framework OpenCL -framework OpenGL -framework GLUT -framework CoreFoundation -framework IOKit -lGLEW
NO_DEBUG = -O2 -framework OpenCL -framework OpenGL -framework GLUT -framework CoreFoundation -framework IOKit -lGLEW
CXX = clang++
CC = clang
BUILD_FOLDER = build/out/
$(info ************  Mode Native : Enabled ************)
else
EXTENSION = js
DEBUG = -s OPT_LEVEL=1 -s DEBUG_LEVEL=1 -s LEGACY_GL_EMULATION=1 -s CL_VALIDATOR=$(VAL) -s CL_VAL_PARAM=$(VALIDATOR) -s CL_PRINT_TRACE=1 -s DISABLE_EXCEPTION_CATCHING=0 -s WARN_ON_UNDEFINED_SYMBOLS=1 -s CL_DEBUG=1 -s CL_GRAB_TRACE=1 -s CL_CHECK_VALID_OBJECT=1 -s TOTAL_MEMORY=1024*1024*750 -DGPU_PROFILING
NO_DEBUG = -s OPT_LEVEL=2 -s DEBUG_LEVEL=0 -s LEGACY_GL_EMULATION=1 -s CL_VALIDATOR=$(VAL) -s CL_VAL_PARAM=$(VALIDATOR) -s WARN_ON_UNDEFINED_SYMBOLS=1 -s CL_DEBUG=0 -s CL_GRAB_TRACE=1 -s CL_PRINT_TRACE=0 -s CL_CHECK_VALID_OBJECT=0 -s TOTAL_MEMORY=1024*1024*750 -DGPU_PROFILING
CXX = $(EMSCRIPTEN_ROOT)/em++
CC = $(EMSCRIPTEN_ROOT)/emcc
BUILD_FOLDER = build/
$(info ************  Mode EMSCRIPTEN : Enabled ************)
endif

ifeq ($(DEB),1)
MODE=$(DEBUG)
EMCCDEBUG = EMCC_FAST_COMPILER=$(FAST) EMCC_DEBUG
$(info ************  Mode DEBUG : Enabled ************)
else
MODE=$(NO_DEBUG)
EMCCDEBUG = EMCC_FAST_COMPILER=$(FAST) EMCCDEBUG
$(info ************  Mode DEBUG : Disabled ************)
endif

$(info )
$(info )


#----------------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------------#
# BUILD
#----------------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------------#

all: all_1 all_2 all_3

all_1: \
	openclpt_sample

all_2: \
	simpleflow_sample

all_3: \

ifeq ($(NAT),1)
openclpt_preload =
else
openclpt_preload = --preload-file camera_complex.cam --preload-file camera_null.cam --preload-file camera.cam --preload-file tracer.cl --preload-file simple.frag --preload-file quad.vert --preload-file kitbox.obj --preload-file matlib.mat --preload-file smallbox.obj 
endif
openclpt_sample:
	$(call chdir,openclpt/openclpt/)
	cp *.cl ../../build/out/
	cp *.frag ../../build/out/
	cp *.vert ../../build/out/	
	cp *.obj ../../build/out/
	cp *.cam ../../build/out/
	cp *.mat ../../build/out/
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-o ../../$(BUILD_FOLDER)/$(PREFIX)openclpt.$(EXTENSION) \
	-I./ \
	clgl.cpp \
	filter.cpp \
	glhelpers.cpp \
	glmain.cpp \
	obj_loader.cpp \
	speedup_grid.cpp \
	Vector.cpp \
	$(openclpt_preload)

ifeq ($(NAT),1)
simpleflow_preload =
else
simpleflow_preload = --preload-file grand_canyon.pgm --preload-file sand.tga --preload-file skymap_b.tga --preload-file stone.tga --preload-file texture.tga --preload-file particleSimulation.cl --preload-file compose.frag --preload-file curvatureflow.frag --preload-file liquidshade.frag --preload-file particledepth.frag --preload-file particlethickness.frag --preload-file particlevelocity.frag --preload-file simple.frag --preload-file particles.vert --preload-file quad.vert --preload-file simple.vert 
endif
simpleflow_sample:
	$(call chdir,simpleflow/WaterSim2/)
	cp *.cl ../../build/out/
	cp *.tga ../../build/out/
	cp *.pgm ../../build/out/
	cp *.frag ../../build/out/
	cp *.vert ../../build/out/
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-I./ \
	clgl.cpp \
	glhelpers.cpp \
	glmain.cpp \
	pgmloader.cpp \
	Vector.cpp \
	$(simpleflow_preload)

clean:
	$(call chdir,build/)
	rm -rf tmp/	
	mkdir tmp
	rm -rf out/	
	mkdir out
	cp memoryprofiler.js tmp/
	cp settings.js tmp/
	rm -f *.data
	rm -f *.js
	rm -f *.map
	cp tmp/memoryprofiler.js ./
	cp tmp/settings.js ./
	rm -rf tmp/
	$(CXX) --clear-cache

	
	
