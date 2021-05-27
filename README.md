# vrago

Variable Rate for Ag Open

## Getting Started

This project is under development.

First set the preferences in the settings menu
- Currently only internal gps supported
- Only PGN mode section flow/dist supported
- Set UDP output (input not used yet)
- Set sections structure (define section # and width in cms, also antenna offset [normal is total width/2])

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

## TO-DO
- AOG as location provider (Over UDP PGN) 
- Read sections from AOG automatically (Over UDP PGN) 
- TCP/UDP Location provider with NMEA parser
- ESP32 Demo code

## Screenshots

| | | |
|:-------------------------:|:-------------------------:|:-------------------------:|
| <img src="https://i.ibb.co/SvQBKDP/Simulator-Screen-Shot-i-Phone-8-2021-05-26-at-22-05-39.png" width="200"> | <img src="https://i.ibb.co/gmRJ1QV/Simulator-Screen-Shot-i-Phone-8-2021-05-26-at-22-12-58.png" width="200"> | <img src="https://i.ibb.co/qNBw9sG/Simulator-Screen-Shot-i-Phone-8-2021-05-26-at-22-13-01.png" width="200">|
| <img src="https://i.ibb.co/9nr9Bx0/Simulator-Screen-Shot-i-Phone-8-2021-05-26-at-22-12-24.png" width="200"> | <img src="https://i.ibb.co/C789gqm/Simulator-Screen-Shot-i-Phone-8-2021-05-26-at-22-12-10.png" width="200"> | <img src="https://i.ibb.co/ZL8c4nV/Simulator-Screen-Shot-i-Phone-8-2021-05-26-at-22-07-23.png" width="200"> |

