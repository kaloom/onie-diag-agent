#-------------------------------------------------------------------------------
#
#
#-------------------------------------------------------------------------------
#
# This is a makefile fragment that copies library for ONIE Probe to sysroot
#

DEMO_INSTALL_SCRIPT = $(abspath ../demo/installer/grub-arch/install.sh)
DEMO_INSTALL_SCRIPT_ORI = $(DEMO_INSTALL_SCRIPT).ori
DEMO_INSTALL_SCRIPT_MACHINE = $(MACHINEDIR)/demo/install.sh
DEMO_SYSROOT_MACHINE_COMPLETE_STAMP = $(STAMPDIR)/sysroot-demo-machine-complete
DEMO_IMAGE_MACHINE_COMPLETE_STAMP = $(STAMPDIR)/demo-image-machine-complete

$(DEMO_SYSROOT_MACHINE_COMPLETE_STAMP): $(DEMO_SYSROOT_COMPLETE_STAMP)
	$(Q) cp -f $(DEMO_INSTALL_SCRIPT) $(DEMO_INSTALL_SCRIPT_ORI)
	$(Q) cp -f $(DEMO_INSTALL_SCRIPT_MACHINE) $(DEMO_INSTALL_SCRIPT)

$(DEMO_IMAGE_MACHINE_COMPLETE_STAMP): $(DEMO_IMAGE_COMPLETE_STAMP)
	$(Q) if [ -f "$(DEMO_INSTALL_SCRIPT_ORI)" ] ; then \
	        cp -f $(DEMO_INSTALL_SCRIPT_ORI) $(DEMO_INSTALL_SCRIPT); \
	        rm -f $(DEMO_INSTALL_SCRIPT_ORI); \
	     fi;

demo-machine-clean:
	$(Q) if [ -f "$(DEMO_INSTALL_SCRIPT_ORI)" ] ; then \
	        cp -f $(DEMO_INSTALL_SCRIPT_ORI) $(DEMO_INSTALL_SCRIPT); \
	        rm -f $(DEMO_INSTALL_SCRIPT_ORI); \
	     fi;

$(MBUILDDIR)/demo.initrd: $(DEMO_SYSROOT_MACHINE_COMPLETE_STAMP)

$(STAMPDIR)/demo-image-complete: $(DEMO_IMAGE_MACHINE_COMPLETE_STAMP)

demo-clean: demo-machine-clean

#-------------------------------------------------------------------------------
#
# Local Variables:
# mode: makefile-gmake
# End:
