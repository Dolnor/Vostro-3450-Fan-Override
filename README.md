             
## Fan control method for OSX

For Vostro 3450 and Inspiron N4110. Also valid for XPS 15 and 17 of Sandy Bridge era, but those will need some tweaking in terms of temps). The control method was discovered by TimeWalker, based on observations from changing register values through RWE and checking register names an purpose from ACPI tables.

There is no ideal method for controlling Fan on this machines even under Windows. Everything that attempts to use Dell's SMI either locks up the system or slows it down (to the point when system becomes unusable). Default Auto behavior kicks the fan on as soon as temperature hits 57C (without calculating average), so every time CPU hits 57C mark Fan is turned on at 3700 RPM (LVL2).

### How it works

* Passive Profile (can work on battery):
- If average temperature is lower than SAFE temperature and fan is already on LVL1 it makes the fan drop speed gradually until it turn off. If fan has turned off the automatic mode is disabled and steady speed mode is activated. 

- When average temperature reaches TRIP temperature automatic control mode is restored to cool down the machine.

There is not way to set desired fan speed, it's done through Dell's proprietary protocol, which creates huge amounts of lag when accessed externally. And even then the fan speed can only be set to two positions - 3700 or 4700 RPM.

* Audible Profile (restricted to AC only):
- If average temp is below SAFE, fas is running at LVL1, and power source is AC adapter - makes the fan speed drop gradually.

- If fan speed has dropped below STDY RPM mark (don’t go below 3000RPM) the fan is getting locked at this steady speed due to automatic mode override.

- When average temperature has reached TRIP tempe or AC adapter is disconnected or fan steady fan speed locked at a higher speed than requested - reenable automatic mode.


### Additions

By using HWMonitor and FakeSMC (with plugins) from bins.zip you will be able to monitor if fan is locked at a steady speed or bios has control over fan. 
The Fan Control entry under Fans & Pumps will say the status - either Auto or Steady.

To switch Fan Control profiles press on HWMonitor menubar icon, select the gear icon (settings) and go to ACPIProbe Profile. By default Auotmatic profile is set at every boot, you can change this by setting the respective profile (PROx) number in ACTV variable.


## Supplemental ACPI table for OSX 

To use both fan control and monitoring features as well as supplemental ACPI table (meant for device injection and device behavior corrections) you need to apply set of DSDT patches to BIOS DSDT via Clover patches. Regardless of what your motherboard is (AMD SG or Intel only) see these plists for reference:

* For Inspiron series machines use ACPI/DSDT/Patches from dsdt_and_kext_patches_AMD_NEC.plist

* For Vostro series machines use ACPI/DSDT/Patches from dsdt_and_kext_patches_ITL_FL.plist 

If you need kernel extension patches they are generally the same in both plist, with the exception of USB3.0 related patches. 

* Patches in AMD_NEC are meant for NEC/Renesas USB 3.0 host controllers 

* Patches in ITL_FL are meant for Fresco Logic FL1009 USB 3.0 host controller


## Supplemental ACPI table includes the following fixes which allows DELL hardware to work properly in OSX:

- PNLF device with additional brightness control mechanism for subtle screen backlight adjustments

- Scaling check to fix soft reboot with full brightness because BIOS is unable to determine last brightness used after rebooting from OSX

- ADP1 power resources for wake defined in order to allow AppleACAdapter to attach (essentially obsolete for ACPIBatteryManager 1.52 and up)

- Memory Controller Hub definition 

- Intel Management Engine definition

- EHCI fixes to allow proper sleep/wake functionality

- LPCB Bridge definition to reduce processor temperatures

- PS2K exposed to VoodooPS2 as OEM make DELL, includes range of fixes that are needed for inverted (special) keyboard mode when media keys are used without pressing Fn

- PS2M defined method to toggle touchpad LED state when VoodooPS2 disable the surface

- Missing EC registers added to toggle touchpad LED and for memory temperature monitoring

- Certain EC queries are overridden to generate fake PS2 scancodes for VoosooPS2 to intercept

- Intel SMBUS Definition as per Macbook reference

- Root Port #1 (ARPT) has AzureWave AW-NB290 AirPort card defined

- Root Port #3 (XHC1) has Fresco Logic (change name accordingly) USB3.0 controller defined

- Root Port #5 (GIGE) has Gigabit Ethernet (change name accordingly) controller defined

- SATA interface has Apple subsystem ID defined

- IGPU BAR1 address declaration for proper backlight control, shared memory defined

- (AMD models only) AMD SwitchableGraphics disabled to conserve battery power and properly wake display

- (Intel models only) Additional Intel IGPU device injections

- HDEF layout and supplemental property injection for HDMI audio pass-through

- DTGP method defined
