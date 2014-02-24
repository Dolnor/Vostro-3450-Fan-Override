             
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
