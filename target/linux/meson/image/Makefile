#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

FAT32_BLOCK_SIZE=1024
FAT32_BLOCKS=$(shell echo $$(($(CONFIG_TARGET_KERNEL_PARTSIZE)*1024*1024/$(FAT32_BLOCK_SIZE))))

define Build/sdcard-img
	$(RM) -f $@.boot
	mkfs.fat -C $@.boot $(FAT32_BLOCKS)
	mkdir -p $(KDIR)/boot.fat

	mcopy -i $@.boot $(KDIR)/uInitrd ::
	mcopy -i $@.boot $(KDIR)/s805_autoscript.scr ::boot.scr
	mcopy -i $@.boot $(KDIR)/s805_autoscript.txt ::boot.txt

	$(CP) $(IMAGE_KERNEL) $(KDIR)/boot.fat/uImage
	mcopy -i $@.boot $(KDIR)/boot.fat/uImage ::

	$(foreach dts,$(shell echo $(DEVICE_DTS)),$(CP) $(DTS_DIR)/$(dts).dtb $(KDIR)/boot.fat/dtb;)
	mcopy -i $@.boot $(KDIR)/boot.fat/dtb ::

	$(RM) -rf $(KDIR)/boot.fat

	./gen_aml_sdcard_img.sh $@ $@.boot $(IMAGE_ROOTFS) \
		$(CONFIG_TARGET_KERNEL_PARTSIZE) $(CONFIG_TARGET_ROOTFS_PARTSIZE)
endef

define Build/uImage-meson
	$(RM) -rf $(KDIR)/uInitrd
	$(RM) -rf $(KDIR)/s805_autoscript.scr
	$(RM) -rf $(KDIR)/s805_autoscript.txt

	$(call Build/uImage,none)

	touch $(KDIR)/uInitrd
	$(CP) s805_autoscript.txt  $(KDIR)/s805_autoscript.txt
	mkimage -A arm -O linux -T script -C none -a 0 -e 0 -n "s805_autoscript.scr" -d s805_autoscript.txt  $(KDIR)/s805_autoscript.scr
endef

### Devices ###
define Device/Default
  PROFILES = Default $$(DEVICE_NAME)
  KERNEL_NAME := Image
  KERNEL_DEPENDS = $$(wildcard $(DTS_DIR)/$$(DEVICE_DTS).dts)
  KERNEL := kernel-bin | uImage-meson none
  FILESYSTEMS := ext4
  IMAGES := sdcard.img
  IMAGE/sdcard.img := sdcard-img $$(DEVICE_NAME)
endef

define Device/thunder-onecloud
  DEVICE_DTS := amlogic/meson8b-onecloud
  DEVICE_TITLE := Thunder OneCloud
  KERNEL_LOADADDR := 0x00208000
endef
ifeq ($(SUBTARGET),meson8b)
  TARGET_DEVICES += thunder-onecloud
endif

$(eval $(call BuildImage))
