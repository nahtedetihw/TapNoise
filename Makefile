TARGET := iphone:clang:latest:13.0
INSTALL_TARGET_PROCESSES = Music
DEBUG = 0
FINALPACKAGE = 1

PREFIX=$(THEOS)/toolchain/Xcode.xctoolchain/usr/bin/
SYSROOT=$(THEOS)/sdks/iPhoneOS14.0.sdk

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = TapNoise
TapNoise_FILES = Tweak.xm
TapNoise_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Music && killall -9 SpringBoard"
