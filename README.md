             
## Fan control method for OSX on Vostro 3450 and Inspiron N4110

Also valid for XPS 15 and 17 of Sandy Bridge era, but those will need some tweaking in terms of temps). The control method was discovered by TimeWalker, based on observations from changing register values through RWE and checking register names an purpose from ACPI tables.

There is no ideal method for controlling Fan on this machines even under Windows. Everything that attempts to use Dell's SMI either locks up the system or slows it down (to the point when system becomes unusable). Default Auto behavior kicks the fan on as soon as temperature hits 57C (without calculating average), so every time CPU hits 57C mark Fan is turned on at 3700 RPM (LVL2).

### How it works
* Default override (custom_ssdt):
- If average temperature is lower than 51C and fan is already on LVL1 it makes the fan drop speed gradually until it turn off. If fan has turned off the automatic mode is disabled and manual mode is getting activated.

- When average temperature reaches 64C automatic control mode is restored to cool down the machine.


There is not way to set desired fan speed, it's done through Dell's proprietary protocol, which creates huge amounts of lag when accessed externally.

* Alternative override (custom_ssdt_alt):
- If average temp is below 51C, fas is running at LVL1, and power source is AC adapter - makes the fan speed drop gradually.

- If fan speed has dropped below 300RPM mark (less audible) the fan is getting locked at this speed due to automatic mode override.

- When average temperature has peaked to 62C - reenable automatic mode.
