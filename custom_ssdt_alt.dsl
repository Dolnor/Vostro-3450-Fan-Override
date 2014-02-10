/*
 * Intel ACPI Component Architecture
 * AML Disassembler version 20100331
 *
 * Disassembly of SSDT-4.aml, Sun Sep  8 13:50:19 2013
 *
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000401 (1025)
 *     Revision         0x02
 *     Checksum         0x54
 *     OEM ID           "DELL "
 *     OEM Table ID     "PollDevc"
 *     OEM Revision     0x00001000 (4096)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20100331 (537920305)
 */
DefinitionBlock ("SSDT-4.aml", "SSDT", 2, "DELL ", "PollDevc", 0x00001000)
{
    External (\_SB_.PCI0.LPCB, DeviceObj)
    External (\_SB_.PCI0.LPCB.EC0_.TCTL)         // Tachometer Control
    External (\_SB_.PCI0.LPCB.EC0_.FLVL, IntObj) // Active Fan Level
    External (\_SB_.PCI0.LPCB.EC0_.SOT1, IntObj) // Battery Voltage (originally 1x16 bit)
    External (\_SB_.PCI0.LPCB.EC0_.SOT0, IntObj)
    External (\_SB_.PCI0.LPCB.EC0_.FANL, IntObj) // Fan Tahcometer reading Low order
    External (\_SB_.PCI0.LPCB.EC0_.FANH, IntObj) // Fan Tachometer reading High order
    External (\_SB_.PCI0.LPCB.EC0_.SYST, IntObj) // Motherboard Temperature
    External (\_SB_.PCI0.LPCB.EC0_.DTS1, IntObj) // Digital Thermal Sensor on CPU Heatsink
    External (\_SB_.PCI0.LPCB.EC0_.DTS2, IntObj) // Digital Thermal Sensor on PCH Die
    External (\_SB_.PCI0.LPCB.EC0_.OTPC, IntObj) // Optical Thermocouple CPU Proximity
    External (\_SB_.PCI0.LPCB.EC0_.ACIN, IntObj) // AC Adapter Status (0 - Battery, 1 - AC)
    External (\_SB_.PCI0.LPCB.EC0_.MUT0)         // EC Mutex (Lock)

    Scope (\_SB.PCI0.LPCB)
    {
        Device (SMCD)
        {
            Name (_HID, "MON0000")        // ACPI Monitoring Device
            Name (KLVN, Zero)             // Don't use Kelvin degrees, use Celsius instead
            Name (TEMP, Package (0x08)    // Define settings for ACPI Temp Sensors
            {
                "CPU Heatsink", 
                "TCPU", 
                "CPU Proximity", 
                "TCPP", 
                "PCH Die", 
                "TPCH", 
                "Mainboard", 
                "TSYS"
            })
            Method (TCPU, 0, NotSerialized) // CPU Hetsink Sensor
            {
                Acquire (^^EC0.MUT0, 0xFFFF)
                Store (^^EC0.DTS1, Local0)
                Release (^^EC0.MUT0)
                Return (Local0)
            }

            Method (TCPP, 0, NotSerialized) // CPU Proximity Sensor
            {
                Acquire (^^EC0.MUT0, 0xFFFF)
                Store (^^EC0.OTPC, Local0)
                Release (^^EC0.MUT0)
                Return (Local0)
            }

            Method (TPCH, 0, NotSerialized) // PCH Die Sensor
            {
                Acquire (^^EC0.MUT0, 0xFFFF)
                Store (^^EC0.DTS2, Local0)
                Release (^^EC0.MUT0)
                Return (Local0)
            }

            Method (TSYS, 0, NotSerialized) // Motherboard Sensor
            {
                Acquire (^^EC0.MUT0, 0xFFFF)
                Store (^^EC0.SYST, Local0)
                Release (^^EC0.MUT0)
                Return (Local0)
            }

            Name (TACH, Package (0x02)     // Define settings for ACPI Tachometer Sensors
            {
                "System Fan", 
                "FAN0"
            })
            Method (FAN0, 0, NotSerialized) // System Fan Sensor
            {
                Acquire (^^EC0.MUT0, 0xFFFF)
                Store (^^EC0.FANH, Local0)
                Store (^^EC0.FANL, Local1)
                Release (^^EC0.MUT0)
                And (Local0, 0xFFFF, Local0)
                And (Local1, 0xFFFF, Local1)
                If (LNotEqual (Local0, Zero))
                {
                    If (LEqual (Local0, 0xFFFF))
                    {
                        Store (Zero, Local0)
                    }
                    Else
                    {
                        Store (0x0100, Local2)
                        Multiply (Local0, Local2, Local3)
                        Add (Local1, Local3, Local4)
                        Store (Local4, Local0)
                    }
                }
                Else
                {
                    Store (Zero, Local0)
                }

                Return (Local0)
            }

            Name (VOLT, Package (0x02)        // Define settings for ACPI Voltage Sensors
            {
                "Battery", 
                "VBAT"
            })
            Method (VBAT, 0, NotSerialized)    // Internal Battery Sensor
            {
                Acquire (^^EC0.MUT0, 0xFFFF)
                Store (^^EC0.SOT0, Local0)
                Store (^^EC0.SOT1, Local1)
                Release (^^EC0.MUT0)
                And (Local0, 0xFFFF, Local0)
                And (Local1, 0xFFFF, Local1)
                If (LNotEqual (Local0, Zero))
                {
                    If (LEqual (Local0, 0xFFFF))
                    {
                        Store (Zero, Local0)
                    }
                    Else
                    {
                        Store (0x0100, Local2)
                        Multiply (Local0, Local2, Local3)
                        Add (Local1, Local3, Local4)
                        Store (Local4, Local0)
                    }
                }
                Else
                {
                    Store (Zero, Local0)
                }

                Return (Local0)
            }
        }

        Device (PLLD)
        {
            Name (_HID, EisaId ("PLL0000"))   // ACPI Polling Device
            
            /* Define settings for ACPI method polling */
            
            Name (INVL, 0x3E8)            // Set Polling interval 1sec
            Name (TOUT, 0x00)             // Set Polling timeout  0sec (continuous polling)
            Name (LOGG, 0x00)             // Disable Console logging of values returned by methods
            Name (LIST, Package (0x03)    // Define methods for ACPI polling
            {
                "TAVG",
                "ADST", 
                "FCTL"
            })
            
            Name (FHST, Buffer (0x10)         // CPU Heatsink temp history
            {
                /* 0000 */    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
                /* 0008 */    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
            })
            
            Name (FIDX, Zero)                 // Current index in buffer above
            Name (FNUM, Zero)                 // Number of entries in above buffer to count in avg
            Name (FSUM, Zero)                 // Current sum of entries in buffer
            
            Method (TAVG, 0, Serialized)
            {
                Store (^^SMCD.TCPU(), Local0) // Store CPU Heatsink temp sa Local0
              
                // Calculate average temperature
                Add (Local0, FSUM, Local1)
                Store (FIDX, Local2)
                Subtract (Local1, DerefOf (Index (FHST, Local2)), Local1)
                Store (Local0, Index (FHST, Local2))
                Store (Local1, FSUM) // Local2 is new sum
                
                // Adjust current index into temp table
                Increment (Local2)
                If (LGreaterEqual (Local2, SizeOf (FHST)))
                {
                    Store (Zero, Local2)
                }
                Store (Local2, FIDX)
                
                // Adjust total items collected in temp table
                Store (FNUM, Local2)
                If (LNotEqual (Local2, SizeOf (FHST)))
                {
                    Increment (Local2)
                    Store (Local2, FNUM)
                }
                
                // Local2 is new sum, Local3 is number of entries in sum
                Divide (Local1, Local2, , Local0) // Local0 is now average temp
                Return (Local0) // Return average temp
            }
            
            Method (ADST, 0, Serialized) // Return AC Adapter Status
            {
                Acquire (^^EC0.MUT0, 0xFFFF)
                Store (^^EC0.ACIN, Local0)
                Release (^^EC0.MUT0)
                Return (Local0)
            }
                
            Method (FCTL, 0, NotSerialized)         // Fan Control Method
            {
                Store (TAVG (), Local0)             // Store average temp as Local0
                Store (ADST(), Local3)              // Store AC adapter status
                Store (^^SMCD.FAN0(), Local2)       // Store fan speed (both high and low order) as Local2
                Acquire (^^EC0.MUT0, 0xFFFF)        // Set EC Lock
                Store (^^EC0.FLVL, Local1)          // Store Fan Level as Local1
                Release (^^EC0.MUT0)                // Release EC Lock

                If (LAnd (LNotEqual (Local1, 0xFF), LNotEqual(Local3, Zero)))   // If Fan Mode is Auto and if not running on battery
                {
                    If (LAnd (LLessEqual (Local0, 0x33), LEqual (Local1, One))) // If avg temp is below 51C and Fan Level is 1 (~3700 RPM)
                    {
                        Acquire (^^EC0.MUT0, 0xFFFF) // Set EC Lock
                        Store (Zero, ^^EC0.FLVL)     // Set Fan Level to 0 to make Fan drop speed gradually
                        Release (^^EC0.MUT0)         // Release EC Lock
                    }
                    
                    If (LAnd (LLessEqual (Local0, 0x34), LLessEqual(Local2, 0xBB8))) // If avg temp is below 52C and Fan RPM is lower than 2850 RPM
                    {
                        Acquire (^^EC0.MUT0, 0xFFFF) // Set EC Lock
                        Store (Zero, ^^EC0.TCTL)     // Set Fan Mode as Manual
                        Release (^^EC0.MUT0)         // Release EC Lock
                    }
                }
                Else                                 // If Fan Mode is Manual
                {
                    If (LGreaterEqual (Local0, 0x3E)) // If avg temp is higher than 62C
                    {
                        Acquire (^^EC0.MUT0, 0xFFFF) // Set EC Lock
                        Store (One, ^^EC0.TCTL)      // Set Fan Mode as Automatic
                        Release (^^EC0.MUT0)         // Release EC Lock
                    }
                }

                Return (Local1)                      // Return Fan Level
            }
        }
    }
}
