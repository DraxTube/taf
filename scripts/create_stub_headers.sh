#!/bin/bash
# Create VDSuite compatibility stub headers for building with VitaSDK
# These provide minimal definitions to allow compilation

set -e

STUBDIR="${VITASDK}/arm-vita-eabi/include"
echo "Creating stub headers in $STUBDIR"

# kernel.h
if [ ! -f "$STUBDIR/kernel.h" ]; then
cat > "$STUBDIR/kernel.h" << 'EOF'
#ifndef _VDSUITE_KERNEL_H_
#define _VDSUITE_KERNEL_H_
#include <psp2/kernel/processmgr.h>
#include <psp2/kernel/threadmgr.h>
#include <psp2/kernel/sysmem.h>
#include <psp2/kernel/modulemgr.h>
#include <psp2/types.h>
#include <stdint.h>
#include <stddef.h>
#define SCE_KERNEL_4KiB           (0x1000)
#define SCE_KERNEL_16KiB          (0x4000)
#define SCE_KERNEL_32KiB          (0x8000)
#define SCE_KERNEL_64KiB          (0x10000)
#define SCE_KERNEL_256KiB         (0x40000)
#define SCE_KERNEL_512KiB         (0x80000)
#define SCE_KERNEL_1MiB           (0x100000)
#define SCE_KERNEL_2MiB           (0x200000)
#define SCE_KERNEL_4MiB           (0x400000)
#define SCE_KERNEL_8MiB           (0x800000)
#define SCE_KERNEL_16MiB          (0x1000000)
#define SCE_KERNEL_32MiB          (0x2000000)
#ifndef SCE_OK
#define SCE_OK 0
#endif
#define SCE_UID_INVALID_UID       ((SceUID)-1)
#define SCE_KERNEL_PROCESS_ID_SELF 0
#define SCE_KERNEL_CPU_MASK_USER_0 (1 << 16)
#define SCE_KERNEL_CPU_MASK_USER_1 (1 << 17)
#define SCE_KERNEL_CPU_MASK_USER_2 (1 << 18)
#define SCE_KERNEL_HIGHEST_PRIORITY_USER        64
#define SCE_KERNEL_DEFAULT_PRIORITY_USER        160
#define SCE_KERNEL_COMMON_QUEUE_HIGHEST_PRIORITY 64
#define SCE_KERNEL_INDIVIDUAL_QUEUE_HIGHEST_PRIORITY 64
#define SCE_KERNEL_EVF_WAITMODE_OR   1
#define SCE_KERNEL_MEMBLOCK_TYPE_USER_CDRAM_RW  0x09408060
#define SCE_KERNEL_ALLOC_MEMBLOCK_ATTR_HAS_ALIGNMENT 0x00000004
typedef struct SceKernelAllocMemBlockOpt {
    uint32_t size;
    uint32_t attr;
    uint32_t alignment;
    uint32_t uidBaseBlock;
    const char *strBaseBlockName;
    uint32_t flags;
    uint32_t reserved[10];
} SceKernelAllocMemBlockOpt;
#endif
EOF
echo "  Created kernel.h"
fi

# kernel/dmacmgr.h
mkdir -p "$STUBDIR/kernel"
if [ ! -f "$STUBDIR/kernel/dmacmgr.h" ]; then
cat > "$STUBDIR/kernel/dmacmgr.h" << 'EOF'
#ifndef _VDSUITE_KERNEL_DMACMGR_H_
#define _VDSUITE_KERNEL_DMACMGR_H_
#endif
EOF
echo "  Created kernel/dmacmgr.h"
fi

# libdbg.h
if [ ! -f "$STUBDIR/libdbg.h" ]; then
cat > "$STUBDIR/libdbg.h" << 'EOF'
#ifndef _VDSUITE_LIBDBG_H_
#define _VDSUITE_LIBDBG_H_
#include <stdio.h>
#define SCE_DBG_LOG_LEVEL_TRACE 0
#undef SCE_DBG_LOG_COMPONENT
#define SCE_DBG_LOG_COMPONENT
#define SCE_DBG_LOG_TRACE(fmt, ...)
#define SCE_DBG_LOG_INFO(fmt, ...)
#define SCE_DBG_LOG_WARNING(fmt, ...)
#define SCE_DBG_LOG_ERROR(fmt, ...)
static inline void sceDbgSetMinimumLogLevel(int level) {}
#endif
EOF
echo "  Created libdbg.h"
fi

# libsysmodule.h
if [ ! -f "$STUBDIR/libsysmodule.h" ]; then
cat > "$STUBDIR/libsysmodule.h" << 'EOF'
#ifndef _VDSUITE_LIBSYSMODULE_H_
#define _VDSUITE_LIBSYSMODULE_H_
#include <psp2/sysmodule.h>
#define SCE_SYSMODULE_FIBER          0x0024
#define SCE_SYSMODULE_NET            0x0001
#define SCE_SYSMODULE_NP             0x0012
#define SCE_SYSMODULE_NP_TUS         0x002D
#define SCE_SYSMODULE_BEISOBMF       0x8001
#define SCE_SYSMODULE_BEMP2SYS       0x8002
#define SCE_SYSMODULE_INTERNAL_BXCE                0x80000005
#define SCE_SYSMODULE_INTERNAL_INI_FILE_PROCESSOR   0x80000006
#define SCE_SYSMODULE_INTERNAL_COMMON_GUI_DIALOG    0x80000019
static inline int sceSysmoduleLoadModuleInternal(int id) { return 0; }
#endif
EOF
echo "  Created libsysmodule.h"
fi

# appmgr.h
if [ ! -f "$STUBDIR/appmgr.h" ]; then
cat > "$STUBDIR/appmgr.h" << 'EOF'
#ifndef _VDSUITE_APPMGR_H_
#define _VDSUITE_APPMGR_H_
#include <psp2/appmgr.h>
#include <stdint.h>
static inline int sceAppMgrGetIdByName(int *pid, const char *name) { return -1; }
static inline int sceAppMgrAppParamGetString(int pid, int param, char *buf, int bufSize) { return 0; }
#endif
EOF
echo "  Created appmgr.h"
fi

# apputil.h
if [ ! -f "$STUBDIR/apputil.h" ]; then
cat > "$STUBDIR/apputil.h" << 'EOF'
#ifndef _VDSUITE_APPUTIL_H_
#define _VDSUITE_APPUTIL_H_
#include <psp2/apputil.h>
#endif
EOF
echo "  Created apputil.h"
fi

# power.h
if [ ! -f "$STUBDIR/power.h" ]; then
cat > "$STUBDIR/power.h" << 'EOF'
#ifndef _VDSUITE_POWER_H_
#define _VDSUITE_POWER_H_
#include <psp2/power.h>
#define SCE_POWER_CONFIGURATION_MODE_C 2
#define SCE_KERNEL_POWER_TICK_DEFAULT 0
#define SCE_KERNEL_POWER_TICK_DISABLE_AUTO_SUSPEND 1
static inline int scePowerSetConfigurationMode(int mode) { return 0; }
static inline int sceKernelPowerTick(int type) { return 0; }
#endif
EOF
echo "  Created power.h"
fi

# net.h
if [ ! -f "$STUBDIR/net.h" ]; then
cat > "$STUBDIR/net.h" << 'EOF'
#ifndef _VDSUITE_NET_H_
#define _VDSUITE_NET_H_
#include <psp2/net/net.h>
typedef struct SceNetInitParam {
    void *memory;
    int size;
    int flags;
} SceNetInitParam;
static inline int sceNetInit(SceNetInitParam *param) { return 0; }
#endif
EOF
echo "  Created net.h"
fi

# libnetctl.h
if [ ! -f "$STUBDIR/libnetctl.h" ]; then
cat > "$STUBDIR/libnetctl.h" << 'EOF'
#ifndef _VDSUITE_LIBNETCTL_H_
#define _VDSUITE_LIBNETCTL_H_
#include <psp2/net/netctl.h>
#define SCE_NET_CTL_STATE_IPOBTAINED 3
static inline int sceNetCtlInit(void) { return 0; }
static inline int sceNetCtlInetGetState(int *state) { if(state) *state = 3; return 0; }
#endif
EOF
echo "  Created libnetctl.h"
fi

# audioout.h
if [ ! -f "$STUBDIR/audioout.h" ]; then
cat > "$STUBDIR/audioout.h" << 'EOF'
#ifndef _VDSUITE_AUDIOOUT_H_
#define _VDSUITE_AUDIOOUT_H_
#include <psp2/audioout.h>
#define SCE_AUDIO_OUT_PORT_TYPE_VOICE 0
#define SCE_AUDIO_VOLUME_0DB 32768
#define SCE_AUDIO_VOLUME_FLAG_L_CH 1
#define SCE_AUDIO_VOLUME_FLAG_R_CH 2
#endif
EOF
echo "  Created audioout.h"
fi

# avcdec.h
if [ ! -f "$STUBDIR/avcdec.h" ]; then
cat > "$STUBDIR/avcdec.h" << 'EOF'
#ifndef _VDSUITE_AVCDEC_H_
#define _VDSUITE_AVCDEC_H_
#define SCE_AVCDEC_PIXEL_RGBA8888 0
#endif
EOF
echo "  Created avcdec.h"
fi

# common_dialog.h
if [ ! -f "$STUBDIR/common_dialog.h" ]; then
cat > "$STUBDIR/common_dialog.h" << 'EOF'
#ifndef _VDSUITE_COMMON_DIALOG_H_
#define _VDSUITE_COMMON_DIALOG_H_
#include <psp2/common_dialog.h>
#endif
EOF
echo "  Created common_dialog.h"
fi

# common_gui_dialog.h
if [ ! -f "$STUBDIR/common_gui_dialog.h" ]; then
cat > "$STUBDIR/common_gui_dialog.h" << 'EOF'
#ifndef _VDSUITE_COMMON_GUI_DIALOG_H_
#define _VDSUITE_COMMON_GUI_DIALOG_H_
#endif
EOF
echo "  Created common_gui_dialog.h"
fi

# ini_file_processor.h
if [ ! -f "$STUBDIR/ini_file_processor.h" ]; then
cat > "$STUBDIR/ini_file_processor.h" << 'EOF'
#ifndef _VDSUITE_INI_FILE_PROCESSOR_H_
#define _VDSUITE_INI_FILE_PROCESSOR_H_
#define SCE_INI_FILE_PROCESSOR_KEY_BUFFER_SIZE 512
#endif
EOF
echo "  Created ini_file_processor.h"
fi

# np.h
if [ ! -f "$STUBDIR/np.h" ]; then
cat > "$STUBDIR/np.h" << 'EOF'
#ifndef _VDSUITE_NP_H_
#define _VDSUITE_NP_H_
#include <psp2/np/np_common.h>
#endif
EOF
echo "  Created np.h"
fi

# ipmi.h
if [ ! -f "$STUBDIR/ipmi.h" ]; then
cat > "$STUBDIR/ipmi.h" << 'EOF'
#ifndef _VDSUITE_IPMI_H_
#define _VDSUITE_IPMI_H_
#endif
EOF
echo "  Created ipmi.h"
fi

# download_service.h
if [ ! -f "$STUBDIR/download_service.h" ]; then
cat > "$STUBDIR/download_service.h" << 'EOF'
#ifndef _VDSUITE_DOWNLOAD_SERVICE_H_
#define _VDSUITE_DOWNLOAD_SERVICE_H_
#endif
EOF
echo "  Created download_service.h"
fi

# psp2_compat/curl/curl.h
mkdir -p "$STUBDIR/psp2_compat/curl"
if [ ! -f "$STUBDIR/psp2_compat/curl/curl.h" ]; then
cat > "$STUBDIR/psp2_compat/curl/curl.h" << 'EOF'
#ifndef _VDSUITE_PSP2_COMPAT_CURL_H_
#define _VDSUITE_PSP2_COMPAT_CURL_H_
#include <curl/curl.h>
#endif
EOF
echo "  Created psp2_compat/curl/curl.h"
fi

# scebeavplayer.h
if [ ! -f "$STUBDIR/scebeavplayer.h" ]; then
cat > "$STUBDIR/scebeavplayer.h" << 'EOF'
#ifndef _VDSUITE_SCEBEAVPLAYER_H_
#define _VDSUITE_SCEBEAVPLAYER_H_
#include <stdint.h>
typedef uint32_t SceBeavCorePlayerHandle;
typedef void* LSInputHandle;
typedef int LSInputResult;
typedef int LSResult;
typedef int LSStatus;
typedef void LSSession;
typedef void LSStreamlist;
typedef void LSStreamfile;
#define LS_INPUT_OK 0
#define LS_INPUT_ERROR_INVALID_URI_PTR -1
#define LS_INPUT_ERROR_INVALID_SIZE_PTR -2
#define LS_INPUT_ERROR_INVALID_BUFFER_PTR -3
#define LS_INPUT_ERROR_INVALID_HANDLE -4
#define LS_INPUT_ERROR_NO_CONNECTION -5
#define LS_INPUT_ERROR_TIME_OUT -6
#define LS_INPUT_ERROR_NOT_SUPPORTED -7
#define LS_OK 0
#define LS_STREAMFILE_ERROR_ABORTED -99
#define LS_BW_CONTROL_DISABLED 0
#define SCE_BEAV_CORE_PLAYER_BW_SELECT_LOWEST 0
#define SCE_BEAV_CORE_PLAYER_PROP_AVCDEC_MEMBLOCK_TYPE 1
#define SCE_BEAV_CORE_PLAYER_PROP_AVCDEC_INIT_WITH_UNMAPMEM 2
#define SCE_BEAV_CORE_PLAYER_PROP_AACDEC_INIT_WITH_UNMAPMEM 3
#define SCE_BEAV_CORE_PLAYER_PROP_MP4DEC_START_TIMEOUT 4
#define SCE_BEAV_CORE_PLAYER_PROP_VDEC_PIXTYPE 5
#define SCE_BEAV_CORE_PLAYER_LOG_LEVEL_CRITICAL 1
#define SCE_BEAV_CORE_PLAYER_LOG_LEVEL_WARNING 2
#define SCE_BEAV_CORE_PLAYER_LOG_LEVEL_VERBOSE 4
typedef struct SceBeavCorePlayerAudioData {
    void *pBuffer;
    uint32_t uPcmSize;
    uint32_t uSampleRate;
    uint32_t uChannelCount;
} SceBeavCorePlayerAudioData;
typedef struct SceBeavCorePlayerVideoData {
    void *pFrameBuffer;
    uint32_t uTexWidth;
    uint32_t uTexHeight;
    uint32_t uTexPitch;
} SceBeavCorePlayerVideoData;
typedef struct {
    LSInputResult (*Open)(char*, uint64_t, uint32_t, LSInputHandle*);
    LSInputResult (*GetSize)(LSInputHandle, uint64_t*);
    LSInputResult (*Read)(LSInputHandle, void*, uint32_t, uint32_t, uint32_t*);
    LSInputResult (*Abort)(LSInputHandle);
    LSInputResult (*Close)(LSInputHandle*);
    LSInputResult (*GetLastError)(LSInputHandle, uint32_t*);
} SceBeavCorePlayerLsInputPluginInterface;
typedef struct {
    int (*lsSetErrorHandler)(uint32_t, LSResult(*)(LSResult, LSSession*, LSStreamlist*, LSStreamfile*, void*), void*);
    int (*lsSetStatusHandler)(uint32_t, LSResult(*)(LSStatus, LSSession*, LSStreamlist*, LSStreamfile*, void*), void*);
    int (*lsStreamlistGetBandwidthTableCount)(LSStreamlist*, uint32_t*);
    int (*lsSessionSetBandwidthControl)(LSSession*, int);
    int (*lsStreamlistGetStreamResolution)(LSStreamlist*, int, uint32_t*, uint32_t*);
    int (*lsStreamlistGetStreamBandwidth)(LSStreamlist*, int, uint32_t*);
    int (*lsStreamlistDisableStream)(LSStreamlist*, int);
    int (*lsStreamlistSelectStream)(LSStreamlist*, int);
    int (*lsStreamlistGetStreamIndex)(LSStreamlist*, int*);
} SceBeavCorePlayerLibLSInterface;
typedef struct {
    uint32_t uNoContentTimeOutSecs;
    uint32_t uNoConnectionTimeOutSecs;
    uint32_t uM3u8RetrySleepMSecs;
    uint32_t uM3u8RetryTimeOutMSecs;
    uint32_t uSegmentMaxRetryCount;
    uint32_t uMinBufferPercentBeforeSwitchUp;
    uint32_t uMinSegmentsStreamedBeforeSwitchUp;
    uint32_t uMaxNumFailOversPerVariant;
    uint32_t uMaxNumVariantsToCache;
    uint32_t uMaxM3U8FileSize;
    uint32_t uM3U8WorkingMemSize;
    uint32_t uMinUnPlayedCachedSegmentsBeforeSwitchUp;
    uint32_t uOptionFlags;
} LSLibraryInitParams;
static inline int sceBeavCorePlayerInitialize(void) { return 1; }
static inline SceBeavCorePlayerHandle sceBeavCorePlayerCreate(void) { return 1; }
static inline void sceBeavCorePlayerDestroy(SceBeavCorePlayerHandle h) {}
static inline void sceBeavCorePlayerFinalize(void) {}
static inline void sceBeavCorePlayerSetAgent(SceBeavCorePlayerHandle h, const char *a) {}
static inline int sceBeavCorePlayerSetVideoBuffer(SceBeavCorePlayerHandle h, int w, int ht, int c, void *b) { return 0; }
static inline void sceBeavCorePlayerSetLsBandwidthOpt(SceBeavCorePlayerHandle h, int s, int a, int b, int c) {}
static inline int sceBeavCorePlayerOpenTargetUrl(SceBeavCorePlayerHandle h, const char *url, int f) { return 1; }
static inline int sceBeavCorePlayerGetAudioData(SceBeavCorePlayerHandle h, SceBeavCorePlayerAudioData *d) { return 0; }
static inline int sceBeavCorePlayerGetVideoData(SceBeavCorePlayerHandle h, SceBeavCorePlayerVideoData *d) { return 0; }
static inline int sceBeavCorePlayerIsReady(SceBeavCorePlayerHandle h) { return 0; }
static inline void sceBeavCorePlayerStop(SceBeavCorePlayerHandle h) {}
static inline uint32_t sceBeavCorePlayerGetTotalTime(SceBeavCorePlayerHandle h) { return 0; }
static inline uint32_t sceBeavCorePlayerGetElapsedTime(SceBeavCorePlayerHandle h) { return 0; }
static inline int sceBeavCorePlayerJumpToTimeCode(SceBeavCorePlayerHandle h, uint32_t t) { return 0; }
static inline int sceBeavCorePlayerGetPlayerState(SceBeavCorePlayerHandle h) { return 0; }
static inline void sceBeavCorePlayerSwitchPlayState(SceBeavCorePlayerHandle h) {}
static inline int sceBeavCorePlayerIsPaused(SceBeavCorePlayerHandle h) { return 0; }
static inline void sceBeavCorePlayerMemmanagerSet(void*(*a)(unsigned int), void*(*b)(unsigned int, unsigned int), void(*c)(void*)) {}
static inline void sceBeavCorePlayerMemmanagerSetGetFreeSize(uint32_t(*f)(void)) {}
static inline void sceBeavCorePlayerLsHttpSetResolveConfig(int a, int b) {}
static inline void sceBeavCorePlayerLsSetTimeout(int a, int b) {}
static inline void sceBeavCorePlayerSetProperty(int p, int v) {}
static inline void sceBeavCorePlayerSetLogLevel(int l) {}
static inline void sceBeavCorePlayerLsHttpSetInputPluginInterface(void *i) {}
static inline int sceBeavCorePlayerGetLibLSInterface(int handle, SceBeavCorePlayerLibLSInterface *iface) { return 0; }
#endif
EOF
echo "  Created scebeavplayer.h"
fi

echo "=== All stub headers created ==="
