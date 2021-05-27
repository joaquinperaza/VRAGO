# vrago

Variable Rate for Ag Open

## Getting Started

This project is under development.

First set the preferences in the settings menu
- Currently only internal gps supported
- Only PGN mode section flow/dist supported
- Set UDP output (input not used yet)
- Set sections structure

Please to test it load a shpafile (.shp+.shx+.dbf). Then app would ask to select one of the numeric columns in your prescription shapefile, and a default rate when no polygon is found. 
__Important: unit should be units/ha.__

PGN Structure (flow/dist mode): 

```
ints = [128, 129, 113, 71, 3, 0, 9, 96, 184]
byte1= 0x80 AOG header1
byte2= 0x81 AOG header2
byte3= Source (VRAGO)
byte4= PGNid
byte5= Length
byte6= Section # (int)
byte7= rateHIGH
byte8= rateLOW
byte9= CRC (AOG-CRC, see calculation in lib/api/UDPManager.dart)
```

The rate bytes define a 2 byte unsigned int that correspond to 10,000X the units to apply in 1 meter of displacement of the section.


