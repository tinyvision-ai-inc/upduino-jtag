//----------------------------------------------------------------------------
//                                                                          --
//                         Module Declaration                               --
//                                                                          --
//----------------------------------------------------------------------------
module rgb_blink (
  // JTAG xlator:

  // TCK
  input wire spi_sck,
  output wire gpio_2,

  // TDI
  output wire gpio_47,
  
  inout wire spi_miso,

  // TDO
  input wire gpio_46,
  output wire gpio_4,
  output wire spi_mosi,

  // TMS
  input wire gpio_23,
  output wire gpio_45,

  // UART
  //input wire gpio_48, // Receive
  //output wire gpio_3, // Transmit

  output wire gpio_48, // Receive
  input wire gpio_3, // Transmit

  // UART selected when these pins are jumpered externally and overrides JTAG
  output wire gpio_38,
  input wire gpio_42,

  output wire spi_ssn,
  // outputs
  output wire led_red  , // Red
  output wire led_blue , // Blue
  output wire led_green  // Green
);

  assign spi_ssn = 1'b1;

// UART only:
//  assign gpio_3 = spi_sck;
//  assign spi_mosi = gpio_48;


// JTAG only:
/*  
  assign gpio_2   = spi_sck; // TCK

  assign gpio_45  = gpio_23; // TMS

  assign gpio_47  = spi_miso; // TDI

  assign spi_mosi = gpio_46; // TDO

  assign gpio_4   = 1'b1; // RSTn/JTAG_SEL

*/

  // JTAG selection logic: set an external jumper between GPIO_38 and GPIO_42 to disable JTAG
  assign gpio_38 = 1'b0;

  wire jtag_sel = gpio_42;

  assign gpio_4   = jtag_sel ? 1'b1 : 1'b0; // RSTn/JTAG_SEL

  // TCK
  assign gpio_2 = jtag_sel ? spi_sck : 1'b1 ;

  // TMS
  assign gpio_45 = jtag_sel ? gpio_23 : 1'b1;

  // TDI
  assign gpio_47 = jtag_sel ? spi_miso : 1'b1;

  // TDO
  assign spi_mosi = gpio_46;


  // UART selected when JTAG isnt being used
  //assign gpio_3   = jtag_sel ? 1'b1 : spi_sck; // UART RX
  //assign spi_mosi = jtag_sel ? gpio_46 : gpio_48; // TDO or UART TX

  assign gpio_48  = jtag_sel ? 1'b1 : spi_sck; // UART TX
  assign spi_miso = jtag_sel ? 1'bz : gpio_3;  // UART RX
  /*
  wire        int_osc            ;
  reg  [27:0] frequency_counter_i;

//----------------------------------------------------------------------------
//                                                                          --
//                       Internal Oscillator                                --
//                                                                          --
//----------------------------------------------------------------------------
  SB_HFOSC u_SB_HFOSC (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));


//----------------------------------------------------------------------------
//                                                                          --
//                       Counter                                            --
//                                                                          --
//----------------------------------------------------------------------------
  always @(posedge int_osc) begin
    frequency_counter_i <= frequency_counter_i + 1'b1;
  end
*/
//----------------------------------------------------------------------------
//                                                                          --
//                       Instantiate RGB primitive                          --
//                                                                          --
//----------------------------------------------------------------------------
  SB_RGBA_DRV RGB_DRIVER (
    .RGBLEDEN(1'b1                                            ),
    //.RGB0PWM (frequency_counter_i[25]&frequency_counter_i[24] ),
    //.RGB1PWM (frequency_counter_i[25]&~frequency_counter_i[24]),
    //.RGB2PWM (~frequency_counter_i[25]&frequency_counter_i[24]),
    .RGB0PWM (jtag_sel),
    .RGB1PWM (~spi_mosi),
    .RGB2PWM (~gpio_23),
    .CURREN  (1'b1                                            ),
    .RGB0    (led_green                                       ), //Actual Hardware connection
    .RGB1    (led_blue                                        ),
    .RGB2    (led_red                                         )
  );
  defparam RGB_DRIVER.RGB0_CURRENT = "0b000001";
  defparam RGB_DRIVER.RGB1_CURRENT = "0b000001";
  defparam RGB_DRIVER.RGB2_CURRENT = "0b000001";


endmodule
