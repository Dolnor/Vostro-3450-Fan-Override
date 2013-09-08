             
Fan control method for OSX on Vostro 3450 
          (and Inspiron 14R,  valid for XPS 15 and 17 of Sandy Bridge era, but those will need some tweaking in terms of temps).
The control method was discovered by TimeWalker, based on observations from changing register values through RWE and checking register names an purpose from ACPI tables.
There is no ideal method for controlling Fan on this machines even under Windows. Everything that attempts to use Dell's SMI either locks up the system or slows it down (to the point when system becomes unusable). Default Auto behavior kicks the fan on as soon as temperature hits 57C (without calculating average), so every time CPU hits 57C mark Fan is turned on at 3700 RPM (LVL2).

* If the fan is already on LVL1 method makes the fan drop speed gradually until it's off if temperature is lower than 51C and disables Auto mode thereafter.
* When average temperature reaches 64C Automatic control mode is restored to cool down the machine.
* There is not way to set desired fan speed, it's done through Dell's SMI protocol, which creates huge amounts of lag when accessed externally.

To set steady RPM one could set EC register FANO to 0 when FLVL register has been set to 0 and Fan still hasn't switched off - the fan speed will lock at the RPM level at which FANO was set to 0.