# JTAG translator using UPduino

## Connections:
1. Cut the Bank 2 VIO sel jumper and short it to VIO. This allows the FPGA bank to be powered from the VIO pin which can be set to the VREF signal from the JTAG port.
2. Make the following connections:
  TCK | gpio_2
  TDI | gpio_47
  TDO | gpio_46
  TMS | gpio_45
  Ground | Ground
  VIO | VREF

In case the target is a 1.8V system, a cheap way to avoid the VREF line is to use a resistive voltage divider to source the VIO pin. This isnt optimal but should work since the power draw from the IO is pretty small. Use 2 470 ohm resistors to divide the 3.3V which will result in 1.65V as the logic level, not ideal but close.
  
The ARM JTAG pinout is as follows:

  Vref      TMS
  GND       TCK
  GND       TDO
  NC        TDI
  GND       RSTn

Mapping to the FPGA pins:
  Vref      TMS (45)
  GND       TCK (2)
  GND       TDO (46)
  NC        TDI (47)
  GND       RSTn
