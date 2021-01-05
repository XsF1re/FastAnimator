GO_EASY_ON_ME = 1
FINALPACKAGE=1
DEBUG=0

ARCHS = arm64 arm64e

THEOS_DEVICE_IP = 10.42.0.33 -p 2222

TARGET := iphone:clang:13.1:7.0
INSTALL_TARGET_PROCESSES = SpringBoard


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FastAnimator

FastAnimator_FILES = Tweak.xm
FastAnimator_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += FastAnimatorPrefs
include $(THEOS_MAKE_PATH)/aggregate.mk 
