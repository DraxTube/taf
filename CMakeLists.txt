cmake_minimum_required(VERSION 3.12)

if(NOT DEFINED CMAKE_TOOLCHAIN_FILE)
  if(DEFINED ENV{VITASDK})
    set(CMAKE_TOOLCHAIN_FILE "$ENV{VITASDK}/share/vita.toolchain.cmake" CACHE PATH "toolchain file")
  else()
    message(FATAL_ERROR "Please define VITASDK to point to your SDK path!")
  endif()
endif()

project(NetStream LANGUAGES C CXX)
set(CMAKE_CXX_STANDARD 11)

include("${VITASDK}/share/vita.cmake" REQUIRED)

set(VITA_APP_NAME "NetStream")
set(VITA_TITLEID  "GRVA00024")
set(VITA_VERSION  "03.33")

# Source files
file(GLOB_RECURSE SRC_FILES
  "${CMAKE_SOURCE_DIR}/NetStream/source/*.cpp"
  "${CMAKE_SOURCE_DIR}/NetStream/source/*.c"
)

# Include directories
include_directories(
  "${CMAKE_SOURCE_DIR}/NetStream/include"
  "${CMAKE_SOURCE_DIR}/NetStream/libs/include"
)

# Compiler flags
add_compile_options(
  -Wall
  -Wno-sign-compare
  -Wno-unused-variable
  -Wno-unused-but-set-variable
  -fno-exceptions
)

add_definitions(
  -DSCE_PAF_TOOL_PRX
)

add_executable(${PROJECT_NAME} ${SRC_FILES})

# Link libraries
# NOTE: Many of these are VDSuite-specific stubs that need the VDSuite SDK.
# If building with open-source VitaSDK, some may need to be replaced or stubbed.
target_link_libraries(${PROJECT_NAME}
  # Project-local stubs
  ${CMAKE_SOURCE_DIR}/NetStream/libs/lib/libFourthTube_stub.a
  ${CMAKE_SOURCE_DIR}/NetStream/libs/lib/libLootkit_stub.a
  ${CMAKE_SOURCE_DIR}/NetStream/libs/lib/libhvdb_stub.a
  ${CMAKE_SOURCE_DIR}/NetStream/libs/lib/libSceAvPlayerWebMAF_stub.a
  ${CMAKE_SOURCE_DIR}/NetStream/libs/lib/libfmodngpext_stub.a

  # VitaSDK stubs (need to be installed in the SDK)
  taihen_stub
  SceRtcUser_stub
  SceIpmi_stub
  SceSysmem_stub
  SceThreadmgr_stub
  SceModulemgr_stub
  SceProcessmgr_stub
  SceTouch_stub
  SceAppMgr_stub
  SceAppUtil_stub
  SceAudio_stub
  SceCtrl_stub
  SceDisplay_stub
  ScePower_stub
  SceSysmodule_stub
  SceRegistryMgr_stub
  SceDbg_stub
  SceLibKernel_stub
  SceNet_stub
  SceNetCtl_stub
  SceCommonDialog_stub
  SceHttp_stub
  SceSsl_stub
  SceAvPlayer_stub
  SceDmacMgr_stub
  SceFiber_stub
  SceVshBridge_stub
  SceNpManager_stub
  SceNpCommon_stub
  SceNpBasic_stub
  SceNpTus_stub
  curl
)

# Create SELF and VPK
vita_create_self(${PROJECT_NAME}.self ${PROJECT_NAME})

vita_create_vpk(${PROJECT_NAME}.vpk ${VITA_TITLEID} ${PROJECT_NAME}.self
  VERSION ${VITA_VERSION}
  NAME ${VITA_APP_NAME}
  FILE ${CMAKE_SOURCE_DIR}/NetStream/CONTENTS/sce_sys/icon0.png sce_sys/icon0.png
  FILE ${CMAKE_SOURCE_DIR}/NetStream/CONTENTS/sce_sys/pic0.png sce_sys/pic0.png
  FILE ${CMAKE_SOURCE_DIR}/NetStream/CONTENTS/sce_sys/livearea/contents/gate.png sce_sys/livearea/contents/gate.png
  FILE ${CMAKE_SOURCE_DIR}/NetStream/CONTENTS/sce_sys/livearea/contents/labg.png sce_sys/livearea/contents/labg.png
  FILE ${CMAKE_SOURCE_DIR}/NetStream/CONTENTS/sce_sys/livearea/contents/template.xml sce_sys/livearea/contents/template.xml
  FILE ${CMAKE_SOURCE_DIR}/NetStream/CONTENTS/sce_sys/livearea/contents/title-en.png sce_sys/livearea/contents/title-en.png
  FILE ${CMAKE_SOURCE_DIR}/NetStream/CONTENTS/module/download_enabler_netstream.suprx module/download_enabler_netstream.suprx
  FILE ${CMAKE_SOURCE_DIR}/NetStream/CONTENTS/module/libFourthTube.suprx module/libFourthTube.suprx
  FILE ${CMAKE_SOURCE_DIR}/NetStream/CONTENTS/module/libLootkit.suprx module/libLootkit.suprx
  FILE ${CMAKE_SOURCE_DIR}/NetStream/CONTENTS/module/libSceAvPlayerPSVitaRGBA8888.suprx module/libSceAvPlayerPSVitaRGBA8888.suprx
  FILE ${CMAKE_SOURCE_DIR}/NetStream/CONTENTS/module/libcurl.suprx module/libcurl.suprx
  FILE ${CMAKE_SOURCE_DIR}/NetStream/CONTENTS/module/libfmodngpext.suprx module/libfmodngpext.suprx
  FILE ${CMAKE_SOURCE_DIR}/NetStream/CONTENTS/module/libfmodstudio.suprx module/libfmodstudio.suprx
  FILE ${CMAKE_SOURCE_DIR}/NetStream/CONTENTS/module/libhvdb.suprx module/libhvdb.suprx
  FILE ${CMAKE_SOURCE_DIR}/NetStream/CONTENTS/netstream_plugin.rco netstream_plugin.rco
)
