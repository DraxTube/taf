TITLE_ID = GRVA00024
TARGET   = NetStream
TITLE    = NetStream
VERSION  = 03.33

PREFIX   = arm-vita-eabi
CC       = $(PREFIX)-gcc
CXX      = $(PREFIX)-g++
STRIP    = $(PREFIX)-strip

CFLAGS   = -Wall -Wno-sign-compare -Wno-unused-variable -Wno-unused-but-set-variable \
           -fno-exceptions -O2 -DSCE_PAF_TOOL_PRX -DNDEBUG -DSCE_DBG_LOGGING_ENABLED=0 \
           -D"__declspec(x)=" -include stdarg.h
CXXFLAGS = $(CFLAGS) -std=c++11 -fno-rtti

# Include directories
INCLUDES = -I$(VITASDK)/arm-vita-eabi/include \
           -INetStream/include \
           -INetStream/libs/include

# Source files
C_SRCS   = $(wildcard NetStream/source/*.c)
CXX_SRCS = $(wildcard NetStream/source/*.cpp) \
           $(wildcard NetStream/source/browsers/*.cpp) \
           $(wildcard NetStream/source/menus/*.cpp) \
           $(wildcard NetStream/source/players/*.cpp) \
           $(wildcard NetStream/source/subs/*.cpp)

OBJS     = $(C_SRCS:.c=.o) $(CXX_SRCS:.cpp=.o)

# Libraries
LIBS = -L$(VITASDK)/arm-vita-eabi/lib \
       -LNetStream/libs/lib \
       -lFourthTube_stub \
       -lLootkit_stub \
       -lhvdb_stub \
       -lSceAvPlayerWebMAF_stub \
       -lfmodngpext_stub \
       -ltaihen_stub \
       -lScePafStdc_stub \
       -lScePafThread_stub \
       -lScePafToplevel_stub \
       -lScePafResource_stub \
       -lScePafWidget_stub \
       -lScePafMisc_stub \
       -lScePafCommon_stub \
       -lScePafGraphics_stub \
       -lSceIniFileProcessor_stub \
       -lSceAppSettings_stub \
       -lSceCommonGuiDialog_stub \
       -lSceRtc_stub \
       -lSceIpmi_stub \
       -lSceSysmem_stub \
       -lSceKernelThreadMgr_stub \
       -lSceKernelModulemgr_stub \
       -lSceProcessmgr_stub \
       -lSceTouch_stub \
       -lSceAppMgr_stub \
       -lSceAppUtil_stub \
       -lSceAudio_stub \
       -lSceCtrl_stub \
       -lSceDisplay_stub \
       -lScePower_stub \
       -lSceSysmodule_stub \
       -lSceRegistryMgr_stub \
       -lSceDbg_stub \
       -lSceLibKernel_stub \
       -lSceNet_stub \
       -lSceNetCtl_stub \
       -lSceCommonDialog_stub \
       -lSceHttp_stub \
       -lSceSsl_stub \
       -lSceAvPlayer_stub \
       -lSceDmacMgr_stub \
       -lSceFiber_stub \
       -lSceVshBridge_stub \
       -lSceNpManager_stub \
       -lSceNpCommon_stub \
       -lSceNpBasic_stub \
       -lSceNpTus_stub \
       -lcurl \
       -lm -lc

.PHONY: all clean vpk

all: $(TARGET).vpk

%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

%.o: %.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

$(TARGET).elf: $(OBJS)
	$(CXX) $(CXXFLAGS) $^ $(LIBS) -Wl,-q -o $@

eboot.bin: $(TARGET).elf
	vita-elf-create $< $@.velf
	vita-make-fself -s $@.velf $@

param.sfo:
	vita-mksfoex -s TITLE_ID=$(TITLE_ID) -s APP_VER=$(VERSION) "$(TITLE)" $@

$(TARGET).vpk: eboot.bin param.sfo
	vita-pack-vpk -s param.sfo -b eboot.bin \
		--add NetStream/CONTENTS/sce_sys/icon0.png=sce_sys/icon0.png \
		--add NetStream/CONTENTS/sce_sys/pic0.png=sce_sys/pic0.png \
		--add NetStream/CONTENTS/sce_sys/livearea/contents/gate.png=sce_sys/livearea/contents/gate.png \
		--add NetStream/CONTENTS/sce_sys/livearea/contents/labg.png=sce_sys/livearea/contents/labg.png \
		--add NetStream/CONTENTS/sce_sys/livearea/contents/template.xml=sce_sys/livearea/contents/template.xml \
		--add NetStream/CONTENTS/sce_sys/livearea/contents/title-en.png=sce_sys/livearea/contents/title-en.png \
		--add NetStream/CONTENTS/module/download_enabler_netstream.suprx=module/download_enabler_netstream.suprx \
		--add NetStream/CONTENTS/module/libFourthTube.suprx=module/libFourthTube.suprx \
		--add NetStream/CONTENTS/module/libLootkit.suprx=module/libLootkit.suprx \
		--add NetStream/CONTENTS/module/libSceAvPlayerPSVitaRGBA8888.suprx=module/libSceAvPlayerPSVitaRGBA8888.suprx \
		--add NetStream/CONTENTS/module/libcurl.suprx=module/libcurl.suprx \
		--add NetStream/CONTENTS/module/libfmodngpext.suprx=module/libfmodngpext.suprx \
		--add NetStream/CONTENTS/module/libfmodstudio.suprx=module/libfmodstudio.suprx \
		--add NetStream/CONTENTS/module/libhvdb.suprx=module/libhvdb.suprx \
		--add NetStream/CONTENTS/netstream_plugin.rco=netstream_plugin.rco \
		$@

vpk: $(TARGET).vpk

clean:
	rm -f $(OBJS) $(TARGET).elf $(TARGET).vpk eboot.bin eboot.bin.velf param.sfo
