///////////////////////////////////
//
// NOTE: A set of precompiler directives configure the features in an FPGA build
// and are listed here. These should be set exclusively using the Makefile mechanism provided.
//
// ETH10G_PORT0 - Ethernet Port0 is configured for 10G (default is 1G)
// ETH10G_PORT1 - Ethernet Port1 is configured for 10G (default is 1G)
// NO_DRAM_FIFOS - All DRAM I/F logic, supporting AXI4 and VFIFOs' replaced by internal SRAM FIFOs.
// DELETE_DSP0 - Deletes DUC and DDC from Radio0
// DELETE_DSP1 - Deletes DUC and DDC from Radio1
// DEBUG_UART - Adds 115kbaud UART to GPIO pins 10 & 11 for firmware debug
//
///////////////////////////////////

//Defines `LVFPGA_IFACE constants
`include "../../lib/io_port2/LvFpga_Chinch_Interface.vh"

module x300

  (
   ///////////////////////////////////
   //
   // Clock sources for main FPGA clocks
   //
   ///////////////////////////////////
   input FPGA_CLK_p,  input FPGA_CLK_n,
   input FPGA_125MHz_CLK,

   ///////////////////////////////////
   //
   // High Speed SPF+ signals and clocking
   //
   ///////////////////////////////////

`ifdef BUILD_1G
   input ETH_CLK_p, input ETH_CLK_n,
`endif

`ifdef BUILD_10G
   input XG_CLK_p, input XG_CLK_n,
`endif

   input SFP0_RX_p, input SFP0_RX_n,
   output SFP0_TX_p, output SFP0_TX_n,
   input SFP1_RX_p, input SFP1_RX_n,
   output SFP1_TX_p, output SFP1_TX_n,

   ///////////////////////////////////
   //
   // DRAM Interface
   //
   ///////////////////////////////////
`ifndef NO_DRAM_FIFOS
   inout [31:0] ddr3_dq,     // Data pins. Input for Reads, Output for Writes.
   inout [3:0] ddr3_dqs_n,   // Data Strobes. Input for Reads, Output for Writes.
   inout [3:0] ddr3_dqs_p,
   //
   output [14:0] ddr3_addr,  // Address
   output [2:0] ddr3_ba,     // Bank Address
   output ddr3_ras_n,        // Row Address Strobe.
   output ddr3_cas_n,        // Column address select
   output ddr3_we_n,         // Write Enable
   output ddr3_reset_n,      // SDRAM reset pin.
   output [0:0] ddr3_ck_p,         // Differential clock
   output [0:0] ddr3_ck_n,
   output [0:0] ddr3_cke,    // Clock Enable
   output [0:0] ddr3_cs_n,         // Chip Select
   output [3:0] ddr3_dm,     // Data Mask [3] = UDM.U26, [2] = LDM.U26, ...
   output [0:0] ddr3_odt,    // On-Die termination enable.
   //
   input sys_clk_i,          // 100MHz clock source to generate DDR3 clocking.
`endif
   ///////////////////////////////////
   //
   // IOPORT2
   //
   ///////////////////////////////////

   //-- The IO_Port2 asynchronous handshaking pins
   input aIoResetIn_n,
   output aIoReadyOut,
   input aIoReadyIn,
   output aIoPort2Restart,
   input aStc3Gpio7,

   //-- The IO_Port2 high speed receiver pins
   input IoRxClock,
   input IoRxClock_n,
   input [15:0] irIoRxData,
   input [15:0] irIoRxData_n,
   input irIoRxHeader,
   input irIoRxHeader_n,

   //-- The IO_Port2 high speed transmitter interface pins
   output IoTxClock,
   output IoTxClock_n,
   output [15:0] itIoTxData,
   output [15:0] itIoTxData_n,
   output itIoTxHeader,
   output itIoTxHeader_n,

   output aIrq,

   ///////////////////////////////////
   //
   // ADC and DAC interfaces
   //
   ///////////////////////////////////

   input DB0_ADC_DCLK_P, input DB0_ADC_DCLK_N,
   input DB0_ADC_DA0_P, input DB0_ADC_DA0_N, input DB0_ADC_DB0_P, input DB0_ADC_DB0_N,
   input DB0_ADC_DA1_P, input DB0_ADC_DA1_N, input DB0_ADC_DB1_P, input DB0_ADC_DB1_N,
   input DB0_ADC_DA2_P, input DB0_ADC_DA2_N, input DB0_ADC_DB2_P, input DB0_ADC_DB2_N,
   input DB0_ADC_DA3_P, input DB0_ADC_DA3_N, input DB0_ADC_DB3_P, input DB0_ADC_DB3_N,
   input DB0_ADC_DA4_P, input DB0_ADC_DA4_N, input DB0_ADC_DB4_P, input DB0_ADC_DB4_N,
   input DB0_ADC_DA5_P, input DB0_ADC_DA5_N, input DB0_ADC_DB5_P, input DB0_ADC_DB5_N,
   input DB0_ADC_DA6_P, input DB0_ADC_DA6_N, input DB0_ADC_DB6_P, input DB0_ADC_DB6_N,

   input DB1_ADC_DCLK_P, input DB1_ADC_DCLK_N,
   input DB1_ADC_DA0_P, input DB1_ADC_DA0_N, input DB1_ADC_DB0_P, input DB1_ADC_DB0_N,
   input DB1_ADC_DA1_P, input DB1_ADC_DA1_N, input DB1_ADC_DB1_P, input DB1_ADC_DB1_N,
   input DB1_ADC_DA2_P, input DB1_ADC_DA2_N, input DB1_ADC_DB2_P, input DB1_ADC_DB2_N,
   input DB1_ADC_DA3_P, input DB1_ADC_DA3_N, input DB1_ADC_DB3_P, input DB1_ADC_DB3_N,
   input DB1_ADC_DA4_P, input DB1_ADC_DA4_N, input DB1_ADC_DB4_P, input DB1_ADC_DB4_N,
   input DB1_ADC_DA5_P, input DB1_ADC_DA5_N, input DB1_ADC_DB5_P, input DB1_ADC_DB5_N,
   input DB1_ADC_DA6_P, input DB1_ADC_DA6_N, input DB1_ADC_DB6_P, input DB1_ADC_DB6_N,

   output DB0_DAC_DCI_P, output DB0_DAC_DCI_N,
   output DB0_DAC_FRAME_P, output DB0_DAC_FRAME_N,
   output DB0_DAC_D0_P, output DB0_DAC_D0_N, output DB0_DAC_D1_P, output DB0_DAC_D1_N,
   output DB0_DAC_D2_P, output DB0_DAC_D2_N, output DB0_DAC_D3_P, output DB0_DAC_D3_N,
   output DB0_DAC_D4_P, output DB0_DAC_D4_N, output DB0_DAC_D5_P, output DB0_DAC_D5_N,
   output DB0_DAC_D6_P, output DB0_DAC_D6_N, output DB0_DAC_D7_P, output DB0_DAC_D7_N,
   output DB0_DAC_ENABLE,

   output DB1_DAC_DCI_P, output DB1_DAC_DCI_N,
   output DB1_DAC_FRAME_P, output DB1_DAC_FRAME_N,
   output DB1_DAC_D0_P, output DB1_DAC_D0_N, output DB1_DAC_D1_P, output DB1_DAC_D1_N,
   output DB1_DAC_D2_P, output DB1_DAC_D2_N, output DB1_DAC_D3_P, output DB1_DAC_D3_N,
   output DB1_DAC_D4_P, output DB1_DAC_D4_N, output DB1_DAC_D5_P, output DB1_DAC_D5_N,
   output DB1_DAC_D6_P, output DB1_DAC_D6_N, output DB1_DAC_D7_P, output DB1_DAC_D7_N,
   output DB1_DAC_ENABLE,

   output DB0_SCLK, output DB0_MOSI,
   output DB0_ADC_SEN, output DB0_DAC_SEN, output DB0_TX_SEN, output DB0_RX_SEN,
   output DB0_RX_LSADC_SEN, output DB0_RX_LSDAC_SEN, output DB0_TX_LSADC_SEN, output DB0_TX_LSDAC_SEN,
   input DB0_RX_LSADC_MISO, input DB0_RX_MISO, input DB0_TX_LSADC_MISO, input DB0_TX_MISO,

   output DB1_SCLK, output DB1_MOSI,
   output DB1_ADC_SEN, output DB1_DAC_SEN, output DB1_TX_SEN, output DB1_RX_SEN,
   output DB1_RX_LSADC_SEN, output DB1_RX_LSDAC_SEN, output DB1_TX_LSADC_SEN, output DB1_TX_LSDAC_SEN,
   input DB1_RX_LSADC_MISO, input DB1_RX_MISO, input DB1_TX_LSADC_MISO, input DB1_TX_MISO,
   output DB_DAC_SCLK, inout DB_DAC_MOSI,

   output DB_ADC_RESET, output DB_DAC_RESET,

   inout DB_SCL, inout DB_SDA,

   ///////////////////////////////////
   //
   // GPIO/LEDS/Etc
   //
   ///////////////////////////////////

   inout [11:0] FrontPanelGpio,

   output LED_ACT1, output LED_ACT2,
   output LED_LINK1, output LED_LINK2,

   output LED_PPS, output LED_REFLOCK, output LED_GPSLOCK,
   output LED_LINKSTAT, output LED_LINKACT,
   output LED_RX1_RX, output LED_RX2_RX,
   output LED_TXRX1_RX, output LED_TXRX1_TX,
   output LED_TXRX2_RX, output LED_TXRX2_TX,
   inout [15:0] DB0_TX_IO,
   inout [15:0] DB0_RX_IO,
   inout [15:0] DB1_TX_IO,
   inout [15:0] DB1_RX_IO,

   ///////////////////////////////////
   //
   // LMK CLock chip
   //
   ///////////////////////////////////

   input [1:0] LMK_Status,
   input LMK_Holdover,
   input LMK_Lock,
   input LMK_Sync, //not used, we do soft sync
   output LMK_SEN, output LMK_MOSI, output LMK_SCLK,

   ///////////////////////////////////
   //
   // GPSDO and Clock Refs
   //
   ///////////////////////////////////

   output [1:0] ClockRefSelect,
   output GPS_SER_IN, input GPS_SER_OUT,
   input GPS_PPS_OUT, input EXT_PPS_IN,
   output EXT_PPS_OUT, input GPS_LOCK_OK,
   output GPSDO_PWR_ENA, output TCXO_ENA,

   output CPRI_CLK_OUT_P, output CPRI_CLK_OUT_N,

   input FPGA_REFCLK_10MHz_p, input FPGA_REFCLK_10MHz_n,

   ///////////////////////////////////
   //
   // Supporting I/O for SPF+ interfaces
   //  (non high speed stuff)
   //
   ///////////////////////////////////

   inout SFPP0_SCL, inout SFPP0_SDA,
   input SFPP0_ModAbs,
   input SFPP0_RxLOS,   // High if module asserts Loss of Signal
   input SFPP0_TxFault, // Current 10G PMA/PCS apparently ignores this signal.
   output SFPP0_RS0,  // These are actually open drain outputs
   output SFPP0_RS1,  // CAUTION! Take great care, this signal shorted to VeeR on SFP module.
   output SFPP0_TxDisable,  // These are actually open drain outputs

   inout SFPP1_SCL, inout SFPP1_SDA,
   input SFPP1_ModAbs,
   input SFPP1_RxLOS,   // High if module asserts Loss of Signal
   input SFPP1_TxFault, // Current 10G PMA/PCS apparently ignores this signal.
   output SFPP1_RS0,  // These are actually open drain outputs
   output SFPP1_RS1,  // CAUTION! Take great care, this signal shorted to VeeR on SFP module.
   output SFPP1_TxDisable, // These are actually open drain outputs

   ///////////////////////////////////
   //
   // Misc.
   //
   ///////////////////////////////////

   input FPGA_PUDC_B
);

   wire         radio_clk, radio_clk_2x, dac_dci_clk;
   wire         global_rst, radio_rst, bus_rst;
   wire [3:0]   sw_rst;
   wire [2:0]   led0, led1;

   /////////////////////////////////////////////////////////////////////
   //
   // Debug logic on front panel GPIO pins
   //
   //////////////////////////////////////////////////////////////////////
   wire     debug_txd, debug_rxd;

   `ifdef DEBUG_UART
   assign FrontPanelGpio[11] = debug_txd;
   assign debug_rxd = FrontPanelGpio[10];
   `endif

   ////////////////////////////////////////////////////////////////////
   //
   // Generate Bus Clock and PCIe Clocks.
   // Source clock comes from U19 which is fixed freq
   // and bufferd to be used by STC3 also (Page17 schematics).
   //
   ////////////////////////////////////////////////////////////////////

   wire     fpga_clk125, bus_clk, ioport2_clk, rio40_clk, ioport2_idelay_ref_clk;
   wire     bus_clk_locked, rio40_clk_locked, rio40_clk_reset;

   IBUFG fpga_125MHz_clk_buf (
     .I(FPGA_125MHz_CLK),
     .O(fpga_clk125));

   //----------------------------------------------------------------------------
   //  Output     Output      Phase    Duty Cycle   Pk-to-Pk     Phase
   //   Clock     Freq (MHz)  (degrees)    (%)     Jitter (ps)  Error (ps)
   //----------------------------------------------------------------------------
   // CLK_OUT1___166.667______0.000______50.0______113.052_____96.948
   // CLK_OUT2___125.000______0.000______50.0______119.348_____96.948
   //
   //----------------------------------------------------------------------------
   // Input Clock   Freq (MHz)    Input Jitter (UI)
   //----------------------------------------------------------------------------
   // __primary_________125.000____________0.010

   wire ioport2_clk_unbuf;

   bus_clk_gen bus_clk_gen (
      .CLK_IN1(fpga_clk125),
      .CLKFB_IN(ioport2_clk),
      .CLK_OUT1(bus_clk),
      .CLK_OUT2_UNBUF(/* unused */),    //This exists to make the IP generate a 125MHz FB clock
      .CLKFB_OUT(ioport2_clk_unbuf),
      .LOCKED(bus_clk_locked));

   BUFG ioport2_clk_bufg_i (
      .O(ioport2_clk),
      .I(ioport2_clk_unbuf));

   //----------------------------------------------------------------------------
   //  Output     Output      Phase    Duty Cycle   Pk-to-Pk     Phase
   //   Clock     Freq (MHz)  (degrees)    (%)     Jitter (ps)  Error (ps)
   //----------------------------------------------------------------------------
   // CLK_OUT1____40.000______0.000______50.0______353.417_____96.948
   // CLK_OUT2___200.000______0.000______50.0______192.299_____96.948
   //
   //----------------------------------------------------------------------------
   // Input Clock   Freq (MHz)    Input Jitter (UI)
   //----------------------------------------------------------------------------
   // __primary_________125.000____________0.100

   //rio40_clk and ioport2_idelay_ref_clk cannot share a PLL/MMCM reset with ioport2_clk
   //so they have to come from a different clocking primitive instance
   pcie_clk_gen pcie_clk_gen (
      .CLK_IN1(fpga_clk125),
      .CLK_OUT1(rio40_clk),
      .CLK_OUT2(ioport2_idelay_ref_clk),
      .RESET(rio40_clk_reset),
      .LOCKED(rio40_clk_locked));

   /////////////////////////////////////////////////////////////////////
   //
   // 10MHz Reference clock
   //
   //////////////////////////////////////////////////////////////////////
   wire ref_clk_10mhz;
   IBUFDS IBUFDS_10_MHz (
        .O(ref_clk_10mhz),
        .I(FPGA_REFCLK_10MHz_p),
        .IB(FPGA_REFCLK_10MHz_n)
    );

   //////////////////////////////////////////////////////////////////////
   // CPRI Clock output -- this is the dirty recovered clock from the MGT
   // This goes to the LMK04816 which locks to it and cleans it up
   // We get the clean versions back as CPRI_CLK (for the CPRI MGT)
   // and FPGA_CLK (for our main rfclk)
   //////////////////////////////////////////////////////////////////////

   wire cpri_clk_out = 1'b0; // FIXME - connect to CPRI clock recovery when implemented
   OBUFDS OBUFDS_cpri (.I(cpri_clk_out), .O(CPRI_CLK_OUT_P), .OB(CPRI_CLK_OUT_N));

   /////////////////////////////////////////////////////////////////////
   //
   // power-on-reset logic.
   //
   //////////////////////////////////////////////////////////////////////
   por_gen por_gen(.clk(bus_clk), .reset_out(global_rst));

   //////////////////////////////////////////////////////////////////////
   wire sync_dacs_radio0, sync_dacs_radio1;
   wire [31:0] rx0, rx1;
   wire [31:0] tx0, tx1;
   wire        sclk0, mosi0, miso0, sclk1, mosi1, miso1;
   wire [7:0]  sen0, sen1;

   wire        set_stb;
   wire [7:0]  set_addr;
   wire [31:0] set_data;

   ////////////////////////////////////////////////////////////////////
   //
   // Generate Radio Clocks from LMK04816
   // Radio clock is normally 200MHz, radio_clk_2x 400MHz.
   // In CPRI or LTE mode, radio clock is 184.32 MHz.
   // radio_clk_2x is only to be used for clocking out TX samples to DAC
   //
   //----------------------------------------------------------------------------
   //  Output     Output      Phase    Duty Cycle   Pk-to-Pk     Phase
   //   Clock     Freq (MHz)  (degrees)    (%)     Jitter (ps)  Error (ps)
   //----------------------------------------------------------------------------
   // CLK_OUT1___200.000______0.000______50.0_______92.799_____82.655
   // CLK_OUT2___400.000____-45.000______50.0_______81.254_____82.655
   // CLK_OUT3___400.000_____60.000______50.0_______81.254_____82.655
   //
   //----------------------------------------------------------------------------
   // Input Clock   Freq (MHz)    Input Jitter (UI)
   //----------------------------------------------------------------------------
   // __primary_________200.000____________0.010
   //
   ////////////////////////////////////////////////////////////////////
   
   wire radio_clk_locked;
   radio_clk_gen radio_clk_gen (
      .CLK_IN1_p(FPGA_CLK_p), .CLK_IN1_n(FPGA_CLK_n),
      .CLK_OUT1(radio_clk), .CLK_OUT2(radio_clk_2x), .CLK_OUT3(dac_dci_clk),
      .RESET(sw_rst[2]), .LOCKED(radio_clk_locked));
   
   ////////////////////////////////////////////////////////////////////
   //
   // IJB. Radio PLL doesn't seem to lock at power up.
   // Probably needs AD9610 to be programmed to 120 or 200MHz to get
   // an input clock thats in the ball park for PLL configuration.
   // Currently use busclk PLL lock signal to control this reset,
   // but we should find a better solution, perhaps a S/W controllable
   // reset like the ETH PHY uses so that we can reset this clock domain
   // after programming the AD9610.
   //
   ////////////////////////////////////////////////////////////////////

   reset_sync radio_reset_sync
     (
      .clk(radio_clk),
      .reset_in(global_rst || !bus_clk_locked || sw_rst[1]),
      .reset_out(radio_rst)
      );

   reset_sync int_reset_sync
     (
      .clk(bus_clk),
      .reset_in(global_rst || !bus_clk_locked),
      .reset_out(bus_rst)
      );

   ////////////////////////////////////////////////////////////////////
   // PPS
   // Support for internal, external, and GPSDO PPS inputs
   // Every attempt to minimize propagation between the external PPS
   // input and outputs to support daisy-chaining the signal.
   ////////////////////////////////////////////////////////////////////

   // Generate an internal PPS signal with a 25% duty cycle
   reg [31:0] pps_count;
   wire int_pps = (pps_count < 32'd2500000);
   always @(posedge ref_clk_10mhz) begin
      if (pps_count >= 32'd9999999)
         pps_count <= 32'b0;
      else
         pps_count <= pps_count + 1'b1;
   end

   // PPS MUX - selects internal, external, or gpsdo PPS
   reg pps;
   wire [1:0] pps_select;
   wire pps_out_enb;
   always @(*) begin
      case(pps_select)
         2'b00  :   pps = EXT_PPS_IN;
         2'b01  :   pps = 1'b0;
         2'b10  :   pps = int_pps;
         2'b11  :   pps = GPS_PPS_OUT;
         default:   pps = 1'b0;
      endcase
   end

   // PPS out and LED
   assign EXT_PPS_OUT = pps & pps_out_enb;
   assign LED_PPS = ~pps;                                  // active low LED driver

   assign LED_GPSLOCK = ~GPS_LOCK_OK;
   assign LED_REFLOCK = ~LMK_Lock;
   assign {LED_RX1_RX,LED_TXRX1_TX,LED_TXRX1_RX} = ~led0;  // active low LED driver
   assign {LED_RX2_RX,LED_TXRX2_TX,LED_TXRX2_RX} = ~led1;  // active low LED driver
   // Allocate SPI chip selects to various slaves.
   assign {DB1_DAC_SEN, DB1_ADC_SEN, DB1_RX_LSADC_SEN, DB1_RX_LSDAC_SEN, DB1_TX_LSADC_SEN, DB1_TX_LSDAC_SEN, DB1_RX_SEN, DB1_TX_SEN} = sen1;
   assign {DB0_DAC_SEN, DB0_ADC_SEN, DB0_RX_LSADC_SEN, DB0_RX_LSDAC_SEN, DB0_TX_LSADC_SEN, DB0_TX_LSDAC_SEN, DB0_RX_SEN, DB0_TX_SEN} = sen0;

   wire        db_dac_mosi_int, db_dac_miso;
   wire        drive_dac_pin;
   reg         drop_dac_pin;
   reg [5:0]   bitcount;
   reg         sclk_d1;

   // Register copy of outgoing DAC clock to do synchronous edge detect.
   always @(posedge radio_clk) sclk_d1 <= DB_DAC_SCLK;

   always @(posedge radio_clk)
     // If neither DAC is selected keep counter reset
     if(DB0_DAC_SEN & DB1_DAC_SEN)
       begin
      bitcount <= 6'd0;
      drop_dac_pin <= 1'b0;
       end
     else if(~DB_DAC_SCLK & sclk_d1)
       // Falling edge of SCLK detected.
       begin
      bitcount <= bitcount + 6'd1;
       end
     else if(bitcount == 0 & DB_DAC_SCLK & ~sclk_d1)
       // On first rising edge store R/W bit to determine if we tristate after 8bits for a Read.
       drop_dac_pin <= db_dac_mosi_int;

   assign drive_dac_pin = (bitcount < 8) | ~drop_dac_pin;

   // Both DAC's use a single SPI bus on PCB. Select appriate Radio to drive the SPi bus by looking at chip selects.
   assign { DB_DAC_SCLK, db_dac_mosi_int } = ~DB0_DAC_SEN ? {sclk0, mosi0} : ~DB1_DAC_SEN ? {sclk1,mosi1} : 2'b0;
   // Data to/from DAC's is bi-dir so tristate driver when reading.
   assign DB_DAC_MOSI = drive_dac_pin ? db_dac_mosi_int : 1'bz;
   // I/O Input buffer
   assign db_dac_miso = DB_DAC_MOSI;

   // If any SPI Slave is selected (except DAC)  then drive SPI clk and MOSI out onto duaghterboard.
   assign { DB0_SCLK, DB0_MOSI } = (~&sen0[6:0]) ? {sclk0,mosi0} : 2'b0;
   assign { DB1_SCLK, DB1_MOSI } = (~&sen1[6:0]) ? {sclk1,mosi1} : 2'b0;

   // Wired OR Mux together the possible sources of read data from SPI devices.
   assign miso0 = (~DB0_RX_LSADC_SEN & DB0_RX_LSADC_MISO) |
          (~DB0_RX_SEN & DB0_RX_MISO) |
          (~DB0_TX_LSADC_SEN & DB0_TX_LSADC_MISO) |
          (~DB0_TX_SEN & DB0_TX_MISO) |
          (~DB0_DAC_SEN & db_dac_miso);

   assign miso1 = (~DB1_RX_LSADC_SEN & DB1_RX_LSADC_MISO) |
          (~DB1_RX_SEN & DB1_RX_MISO) |
          (~DB1_TX_LSADC_SEN & DB1_TX_LSADC_MISO) |
          (~DB1_TX_SEN & DB1_TX_MISO) |
          (~DB1_DAC_SEN & db_dac_miso);


   wire [15:0] radio0_misc_out, radio1_misc_out;
   wire [15:0] radio0_misc_in, radio1_misc_in;

   /////////////////////////////////////////////////////////////////////
   //
   // ADC Interface for ADS62P48
   //
   /////////////////////////////////////////////////////////////////////
   wire [13:0] rx0_q_inv, rx1_q_inv, rx0_i, rx1_i;
   // Analog diff pairs on I side of ADC are inverted for layout reasons, but data diff pairs are all swapped as well
   //  so I gets a double negative, and is unchanged.  Q must be inverted.

   capture_ddrlvds #(
      .WIDTH(14),
      .PATT_CHECKER("TRUE"),
      .DATA_IDELAY_MODE("DYNAMIC"), .DATA_IDELAY_VAL(16), .DATA_IDELAY_FREF(200.0)
   ) cap_db0 (
      .adc_clk_p(DB0_ADC_DCLK_P), .adc_clk_n(DB0_ADC_DCLK_N),
      .adc_data_p(
        {{DB0_ADC_DA6_P, DB0_ADC_DA5_P, DB0_ADC_DA4_P, DB0_ADC_DA3_P, DB0_ADC_DA2_P, DB0_ADC_DA1_P, DB0_ADC_DA0_P},
         {DB0_ADC_DB6_P, DB0_ADC_DB5_P, DB0_ADC_DB4_P, DB0_ADC_DB3_P, DB0_ADC_DB2_P, DB0_ADC_DB1_P, DB0_ADC_DB0_P}}),
      .adc_data_n(
        {{DB0_ADC_DA6_N, DB0_ADC_DA5_N, DB0_ADC_DA4_N, DB0_ADC_DA3_N, DB0_ADC_DA2_N, DB0_ADC_DA1_N, DB0_ADC_DA0_N},
         {DB0_ADC_DB6_N, DB0_ADC_DB5_N, DB0_ADC_DB4_N, DB0_ADC_DB3_N, DB0_ADC_DB2_N, DB0_ADC_DB1_N, DB0_ADC_DB0_N}}),
      .radio_clk(radio_clk),
      .data_delay_stb(radio0_misc_out[3]), .data_delay_val(radio0_misc_out[8:4]),
      .adc_cap_clk(),
      .data_out({rx0_i,rx0_q_inv}),
      .checker_en(radio0_misc_out[9]), .checker_locked(radio0_misc_in[3:0]), .checker_failed(radio0_misc_in[7:4])
   );
   assign rx0[31:0] = { rx0_i, 2'b00, ~rx0_q_inv, 2'b00 };

   capture_ddrlvds #(
      .WIDTH(14),
      .PATT_CHECKER("TRUE"),
      .DATA_IDELAY_MODE("DYNAMIC"), .DATA_IDELAY_VAL(16), .DATA_IDELAY_FREF(200.0)
   ) cap_db1 (
      .adc_clk_p(DB1_ADC_DCLK_P), .adc_clk_n(DB1_ADC_DCLK_N),
      .adc_data_p(
        {{DB1_ADC_DA6_P, DB1_ADC_DA5_P, DB1_ADC_DA4_P, DB1_ADC_DA3_P, DB1_ADC_DA2_P, DB1_ADC_DA1_P, DB1_ADC_DA0_P},
         {DB1_ADC_DB6_P, DB1_ADC_DB5_P, DB1_ADC_DB4_P, DB1_ADC_DB3_P, DB1_ADC_DB2_P, DB1_ADC_DB1_P, DB1_ADC_DB0_P}}),
      .adc_data_n(
        {{DB1_ADC_DA6_N, DB1_ADC_DA5_N, DB1_ADC_DA4_N, DB1_ADC_DA3_N, DB1_ADC_DA2_N, DB1_ADC_DA1_N, DB1_ADC_DA0_N},
         {DB1_ADC_DB6_N, DB1_ADC_DB5_N, DB1_ADC_DB4_N, DB1_ADC_DB3_N, DB1_ADC_DB2_N, DB1_ADC_DB1_N, DB1_ADC_DB0_N}}),
      .radio_clk(radio_clk),
      .data_delay_stb(radio1_misc_out[3]), .data_delay_val(radio1_misc_out[8:4]),
      .adc_cap_clk(),
      .data_out({rx1_i,rx1_q_inv}),
      .checker_en(radio1_misc_out[9]), .checker_locked(radio1_misc_in[3:0]), .checker_failed(radio1_misc_in[7:4])
   );
   assign rx1[31:0] = { rx1_i, 2'b00, ~rx1_q_inv, 2'b00 };

   // IDELAYCTRL to calibrate all IDELAYE2 instances in capture_ddrlvds for both sides
   IDELAYCTRL adc_cap_idelayctrl_i (.RDY(), .REFCLK(radio_clk), .RST(radio_rst)); 

   /////////////////////////////////////////////////////////////////////
   //
   // DAC Interface for AD9146
   //
   /////////////////////////////////////////////////////////////////////
   gen_ddrlvds gen_db0
     (
      .reset(radio_rst),
      .tx_clk_2x_p(DB0_DAC_DCI_P), .tx_clk_2x_n(DB0_DAC_DCI_N),
      .tx_frame_p(DB0_DAC_FRAME_P), .tx_frame_n(DB0_DAC_FRAME_N),
      .tx_d_p({DB0_DAC_D7_P,DB0_DAC_D6_P,DB0_DAC_D5_P,DB0_DAC_D4_P,DB0_DAC_D3_P,DB0_DAC_D2_P,DB0_DAC_D1_P,DB0_DAC_D0_P}),
      .tx_d_n({DB0_DAC_D7_N,DB0_DAC_D6_N,DB0_DAC_D5_N,DB0_DAC_D4_N,DB0_DAC_D3_N,DB0_DAC_D2_N,DB0_DAC_D1_N,DB0_DAC_D0_N}),
      .tx_clk_2x(radio_clk_2x), .tx_clk_1x(radio_clk), .tx_dci_clk(dac_dci_clk),
      .i(~tx0[31:16]), .q(~tx0[15:0]), // invert b/c Analog diff pairs are swapped for layout
      .sync_dacs(sync_dacs_radio0|sync_dacs_radio1)
      );


   gen_ddrlvds gen_db1
     (
      .reset(radio_rst),
      .tx_clk_2x_p(DB1_DAC_DCI_P), .tx_clk_2x_n(DB1_DAC_DCI_N),
      .tx_frame_p(DB1_DAC_FRAME_P), .tx_frame_n(DB1_DAC_FRAME_N),
      .tx_d_p({DB1_DAC_D7_P,DB1_DAC_D6_P,DB1_DAC_D5_P,DB1_DAC_D4_P,DB1_DAC_D3_P,DB1_DAC_D2_P,DB1_DAC_D1_P,DB1_DAC_D0_P}),
      .tx_d_n({DB1_DAC_D7_N,DB1_DAC_D6_N,DB1_DAC_D5_N,DB1_DAC_D4_N,DB1_DAC_D3_N,DB1_DAC_D2_N,DB1_DAC_D1_N,DB1_DAC_D0_N}),
      .tx_clk_2x(radio_clk_2x), .tx_clk_1x(radio_clk), .tx_dci_clk(dac_dci_clk),
      .i(~tx1[31:16]), .q(~tx1[15:0]), // invert b/c Analog diff pairs are swapped for layout
      .sync_dacs(sync_dacs_radio0|sync_dacs_radio1)
      );


   wire [7:0] leds;
   assign { LED_ACT1, LED_ACT2,
        LED_LINK1, LED_LINK2,
        LED_LINKSTAT, LED_LINKACT } = ~leds;

   wire [31:0] debug;

   //////////////////////////////////////////////////////////////////////
   //
   // PCIe Stuff
   //
   //////////////////////////////////////////////////////////////////////

   localparam IOP2_MSG_WIDTH       = 64;
   localparam DMA_STREAM_WIDTH     = `LVFPGA_IFACE_DMA_CHAN_WIDTH;
   localparam DMA_COUNT_WIDTH      = `LVFPGA_IFACE_DMA_SIZE_WIDTH;
   localparam NUM_TX_STREAMS       = `LVFPGA_IFACE_NUM_TX_DMA_CNT;
   localparam NUM_RX_STREAMS       = `LVFPGA_IFACE_NUM_RX_DMA_CNT;
   localparam TX_STREAM_START_IDX  = `LVFPGA_IFACE_TX_DMA_INDEX;
   localparam RX_STREAM_START_IDX  = `LVFPGA_IFACE_RX_DMA_INDEX;

   wire [DMA_STREAM_WIDTH-1:0] dmatx_tdata,  dmarx_tdata,  pcii_tdata,  pcio_tdata;
   wire                        dmatx_tvalid, dmarx_tvalid, pcii_tvalid, pcio_tvalid;
   wire                        dmatx_tlast,  dmarx_tlast,  pcii_tlast,  pcio_tlast;
   wire                        dmatx_tready, dmarx_tready, pcii_tready, pcio_tready;

   wire [IOP2_MSG_WIDTH-1:0]   o_iop2_msg_tdata, i_iop2_msg_tdata;
   wire                        o_iop2_msg_tvalid, o_iop2_msg_tlast, o_iop2_msg_tready;
   wire                        i_iop2_msg_tvalid, i_iop2_msg_tlast, i_iop2_msg_tready;

   wire            pcie_usr_reg_wr, pcie_usr_reg_rd, pcie_usr_reg_rc, pcie_usr_reg_rdy;
   wire [1:0]      pcie_usr_reg_len;
   wire [19:0]     pcie_usr_reg_addr;
   wire [31:0]     pcie_usr_reg_data_in, pcie_usr_reg_data_out;

   wire            chinch_reg_wr, chinch_reg_rd, chinch_reg_rc, chinch_reg_rdy;
   wire [1:0]      chinch_reg_len;
   wire [19:0]     chinch_reg_addr;
   wire [31:0]     chinch_reg_data_out;
   wire [63:0]     chinch_reg_data_in;

   wire [(NUM_TX_STREAMS*DMA_STREAM_WIDTH)-1:0]    dmatx_tdata_iop2;
   wire [NUM_TX_STREAMS-1:0]                       dmatx_tvalid_iop2, dmatx_tready_iop2;

   wire [(NUM_RX_STREAMS*DMA_STREAM_WIDTH)-1:0]    dmarx_tdata_iop2;
   wire [NUM_RX_STREAMS-1:0]                       dmarx_tvalid_iop2, dmarx_tready_iop2;

   //PCIe Express "Physical" DMA and Register logic
   LvFpga_Chinch_Interface lvfpga_chinch_inst
   (
      .aIoResetIn_n(aIoResetIn_n),
      .bBusReset(),   //Output

      // Clocks
      .BusClk(ioport2_clk),
      .Rio40Clk(rio40_clk),
      .IDelayRefClk(ioport2_idelay_ref_clk),
      .aRioClkPllLocked(rio40_clk_locked),
      .aRioClkPllReset(rio40_clk_reset),

      // The IO_Port2 asynchronous handshaking pins
      .aIoReadyOut(aIoReadyOut),
      .aIoReadyIn(aIoReadyIn),
      .aIoPort2Restart(aIoPort2Restart),

      // The IO_Port2 high speed receiver pins
      .IoRxClock(IoRxClock),
      .IoRxClock_n(IoRxClock_n),
      .irIoRxData(irIoRxData),
      .irIoRxData_n(irIoRxData_n),
      .irIoRxHeader(irIoRxHeader),
      .irIoRxHeader_n(irIoRxHeader_n),

      // The IO_Port2 high speed transmitter interface pins
      .IoTxClock(IoTxClock),
      .IoTxClock_n(IoTxClock_n),
      .itIoTxData(itIoTxData),
      .itIoTxData_n(itIoTxData_n),
      .itIoTxHeader(itIoTxHeader),
      .itIoTxHeader_n(itIoTxHeader_n),

      // DMA TX Fifos
      .bDmaTxData(dmatx_tdata_iop2),
      .bDmaTxValid(dmatx_tvalid_iop2),
      .bDmaTxReady(dmatx_tready_iop2),
      .bDmaTxEnabled(),
      .bDmaTxFifoFullCnt(),

      // DMA RX Fifos
      .bDmaRxData(dmarx_tdata_iop2),
      .bDmaRxValid(dmarx_tvalid_iop2),
      .bDmaRxReady(dmarx_tready_iop2),
      .bDmaRxEnabled(),
      .bDmaRxFifoFreeCnt(),

      // User Register Port In
      .bUserRegPortInWt(pcie_usr_reg_wr),
      .bUserRegPortInRd(pcie_usr_reg_rd),
      .bUserRegPortInAddr(pcie_usr_reg_addr),
      .bUserRegPortInData(pcie_usr_reg_data_in),
      .bUserRegPortInSize(pcie_usr_reg_len),

      // User Register Port Out
      .bUserRegPortOutData(pcie_usr_reg_data_out),
      .bUserRegPortOutDataValid(pcie_usr_reg_rc),
      .bUserRegPortOutReady(pcie_usr_reg_rdy),

      // Chinch Register Port Out
      .bChinchRegPortOutWt(chinch_reg_wr),
      .bChinchRegPortOutRd(chinch_reg_rd),
      .bChinchRegPortOutAddr({12'h0, chinch_reg_addr}),
      .bChinchRegPortOutData({32'h0, chinch_reg_data_out}),
      .bChinchRegPortOutSize(chinch_reg_len),

      // User Register Port In
      .bChinchRegPortInData(chinch_reg_data_in),
      .bChinchRegPortInDataValid(chinch_reg_rc),
      .bChinchRegPortInReady(chinch_reg_rdy),

      // Level interrupt
      .aIrq(aIrq)
   );

   //PCIe Express adapter logic to link to the AXI crossbar and the WB bus
   x300_pcie_int #(
      .DMA_STREAM_WIDTH(DMA_STREAM_WIDTH),
      .NUM_TX_STREAMS(NUM_TX_STREAMS),
      .NUM_RX_STREAMS(NUM_RX_STREAMS),
      .REGPORT_ADDR_WIDTH(20),
      .REGPORT_DATA_WIDTH(32),
      .IOP2_MSG_WIDTH(IOP2_MSG_WIDTH)
   ) x300_pcie_int (
      .ioport2_clk(ioport2_clk),
      .bus_clk(bus_clk),
      .bus_rst(bus_rst),

      //DMA TX FIFOs (IoPort2 Clock Domain)
      .dmatx_tdata_iop2(dmatx_tdata_iop2),
      .dmatx_tvalid_iop2(dmatx_tvalid_iop2),
      .dmatx_tready_iop2(dmatx_tready_iop2),

      //DMA TX FIFOs (IoPort2 Clock Domain)
      .dmarx_tdata_iop2(dmarx_tdata_iop2),
      .dmarx_tvalid_iop2(dmarx_tvalid_iop2),
      .dmarx_tready_iop2(dmarx_tready_iop2),

      //PCIe User Regport
      .pcie_usr_reg_wr(pcie_usr_reg_wr),
      .pcie_usr_reg_rd(pcie_usr_reg_rd),
      .pcie_usr_reg_addr(pcie_usr_reg_addr),
      .pcie_usr_reg_data_in(pcie_usr_reg_data_in),
      .pcie_usr_reg_len(pcie_usr_reg_len),
      .pcie_usr_reg_data_out(pcie_usr_reg_data_out),
      .pcie_usr_reg_rc(pcie_usr_reg_rc),
      .pcie_usr_reg_rdy(pcie_usr_reg_rdy),

      //Chinch Regport
      .chinch_reg_wr(chinch_reg_wr),
      .chinch_reg_rd(chinch_reg_rd),
      .chinch_reg_addr(chinch_reg_addr),
      .chinch_reg_data_out(chinch_reg_data_out),
      .chinch_reg_len(chinch_reg_len),
      .chinch_reg_data_in(chinch_reg_data_in[31:0]),
      .chinch_reg_rc(chinch_reg_rc),
      .chinch_reg_rdy(chinch_reg_rdy),

      //DMA TX FIFO (Bus Clock Domain)
      .dmatx_tdata(dmatx_tdata),
      .dmatx_tlast(dmatx_tlast),
      .dmatx_tvalid(dmatx_tvalid),
      .dmatx_tready(dmatx_tready),

      //DMA RX FIFO (Bus Clock Domain)
      .dmarx_tdata(dmarx_tdata),
      .dmarx_tlast(dmarx_tlast),
      .dmarx_tvalid(dmarx_tvalid),
      .dmarx_tready(dmarx_tready),

      //Message FIFO Out (Bus Clock Domain)
      .rego_tdata(o_iop2_msg_tdata),
      .rego_tvalid(o_iop2_msg_tvalid),
      .rego_tlast(o_iop2_msg_tlast),
      .rego_tready(o_iop2_msg_tready),

      //Message FIFO In (Bus Clock Domain)
      .regi_tdata(i_iop2_msg_tdata),
      .regi_tvalid(i_iop2_msg_tvalid),
      .regi_tlast(i_iop2_msg_tlast),
      .regi_tready(i_iop2_msg_tready),

      //Misc
      .misc_status({15'h0, aStc3Gpio7}),
      .debug()
   );

   // The PCIe logic will tend to stay close to the physical IoPort2 pins
   // so add an additional stage of pipelining to give the tool more routing
   // slack. This is significantly help timing closure.
   
   axi_fifo_short #(.WIDTH(DMA_STREAM_WIDTH+1)) pcii_pipeline_srl (
      .clk(bus_clk), .reset(bus_rst), .clear(1'b0),
      .i_tdata({dmatx_tlast, dmatx_tdata}), .i_tvalid(dmatx_tvalid), .i_tready(dmatx_tready),
      .o_tdata({pcii_tlast, pcii_tdata}), .o_tvalid(pcii_tvalid), .o_tready(pcii_tready),
      .space(), .occupied());

   axi_fifo_short #(.WIDTH(DMA_STREAM_WIDTH+1)) pcio_pipeline_srl (
      .clk(bus_clk), .reset(bus_rst), .clear(1'b0),
      .i_tdata({pcio_tlast, pcio_tdata}), .i_tvalid(pcio_tvalid), .i_tready(pcio_tready),
      .o_tdata({dmarx_tlast, dmarx_tdata}), .o_tvalid(dmarx_tvalid), .o_tready(dmarx_tready),
      .space(), .occupied());

   //////////////////////////////////////////////////////////////////////
   //
   // Configure Ethernet PHY clocking
   //
   //////////////////////////////////////////////////////////////////////
`ifdef BUILD_1G
   wire  gige_refclk;

   one_gige_phy_clk_gen gige_clk_gen_i (
      .areset(global_rst | sw_rst[0]),
      .refclk_p(ETH_CLK_p),
      .refclk_n(ETH_CLK_n),
      .refclk(gige_refclk)
   );
`endif
`ifdef BUILD_10G
   wire  xgige_refclk;
   wire  xgige_clk156;
   wire  xgige_dclk;
   
   ten_gige_phy_clk_gen xgige_clk_gen_i (
      .areset(global_rst | sw_rst[0]),
      .refclk_p(XG_CLK_p),
      .refclk_n(XG_CLK_n),
      .refclk(xgige_refclk),
      .clk156(xgige_clk156),
      .dclk(xgige_dclk)
   );
`endif

   //////////////////////////////////////////////////////////////////////
   //
   // Configure Ethernet PHY implemented for PORT0
   //
   //////////////////////////////////////////////////////////////////////
   wire        mdc0, mdio_in0, mdio_out0, mdio_tri0;
   wire [4:0]  prtad0 = 5'b00100;  // MDIO address is 4
   wire [15:0] eth0_phy_status;

`ifdef ETH10G_PORT0
   //////////////////////////////////////////////////////////////////////
   //
   // 10GBaseR PHY with XGMII interface to MAC
   //
   //////////////////////////////////////////////////////////////////////
   wire        xgmii_clk0;  // 156.25MHz
   wire [63:0] xgmii_txd0;
   wire [7:0]  xgmii_txc0;
   wire [63:0] xgmii_rxd0;
   wire [7:0]  xgmii_rxc0;

   wire [7:0]  xgmii_status0;
   wire        xge_phy_resetdone0;

   ten_gige_phy ten_gige_phy_port0
   (
      // Clocks and Reset
      .areset(global_rst | sw_rst[0]), // Asynchronous reset for entire core.
      .refclk(xgige_refclk),           // Transciever reference clock: 156.25MHz
      .clk156(xgige_clk156),           // Globally buffered core clock: 156.25MHz
      .dclk(xgige_dclk),               // Management/DRP clock: 78.125MHz
      .sim_speedup_control(1'b0),
      // GMII Interface (client MAC <=> PCS)
      .xgmii_txd(xgmii_txd0),          // Transmit data from client MAC.
      .xgmii_txc(xgmii_txc0),          // Transmit control signal from client MAC.
      .xgmii_rxd(xgmii_rxd0),          // Received Data to client MAC.
      .xgmii_rxc(xgmii_rxc0),          // Received control signal to client MAC.
      // Tranceiver Interface
      .txp(SFP0_TX_p),                 // Differential +ve of serial transmission from PMA to PMD.
      .txn(SFP0_TX_n),                 // Differential -ve of serial transmission from PMA to PMD.
      .rxp(SFP0_RX_p),                 // Differential +ve for serial reception from PMD to PMA.
      .rxn(SFP0_RX_n),                 // Differential -ve for serial reception from PMD to PMA.
      // Management: MDIO Interface
      .mdc(mdc0),                      // Management Data Clock
      .mdio_in(mdio_in0),              // Management Data In
      .mdio_out(mdio_out0),            // Management Data Out
      .mdio_tri(mdio_tri0),            // Management Data Tristate
      .prtad(prtad0),
      // General IO's
      .core_status(xgmii_status0),     // Core status
      .resetdone(xge_phy_resetdone0),
      .signal_detect(~SFPP0_RxLOS),    // Input from PMD to indicate presence of optical input. (Undocumented, but it seems Xilinx expect this to be inverted.)
      .tx_fault(SFPP0_TxFault),
      .tx_disable(SFPP0_TxDisable)
   );
   
   assign xgmii_clk0       = xgige_clk156;
   assign eth0_phy_status  = {8'h00, xgmii_status0};

`else

   //////////////////////////////////////////////////////////////////////
   //
   // 1000Base-X PHY with GMII interface to MAC
   //
   //////////////////////////////////////////////////////////////////////
   wire [7:0]  gmii_txd0, gmii_rxd0;
   wire        gmii_tx_en0, gmii_tx_er0, gmii_rx_dv0, gmii_rx_er0;
   wire        gmii_clk0;
   wire [15:0] gmii_status0;

   assign SFPP0_TxDisable = 1'b0; // Always on.

   one_gige_phy one_gige_phy_port0 
   (
      .reset(global_rst | sw_rst[0]),  // Asynchronous reset for entire core.
      .independent_clock(bus_clk),
      // Tranceiver Interface
      .gtrefclk(gige_refclk),          // Reference clock for MGT: 125MHz, very high quality.
      .txp(SFP0_TX_p),                 // Differential +ve of serial transmission from PMA to PMD.
      .txn(SFP0_TX_n),                 // Differential -ve of serial transmission from PMA to PMD.
      .rxp(SFP0_RX_p),                 // Differential +ve for serial reception from PMD to PMA.
      .rxn(SFP0_RX_n),                 // Differential -ve for serial reception from PMD to PMA.
      // GMII Interface (client MAC <=> PCS)
      .gmii_clk(gmii_clk0),            // Clock to client MAC.
      .gmii_txd(gmii_txd0),            // Transmit data from client MAC.
      .gmii_tx_en(gmii_tx_en0),        // Transmit control signal from client MAC.
      .gmii_tx_er(gmii_tx_er0),        // Transmit control signal from client MAC.
      .gmii_rxd(gmii_rxd0),            // Received Data to client MAC.
      .gmii_rx_dv(gmii_rx_dv0),        // Received control signal to client MAC.
      .gmii_rx_er(gmii_rx_er0),        // Received control signal to client MAC.
      // Management: MDIO Interface
      .mdc(mdc0),                      // Management Data Clock
      .mdio_i(mdio_in0),               // Management Data In
      .mdio_o(mdio_out0),              // Management Data Out
      .mdio_t(mdio_tri0),              // Management Data Tristate
      .configuration_vector(5'd0),     // Alternative to MDIO interface.
      .configuration_valid(1'b1),      // Validation signal for Config vector (MUST be 1 for proper functionality...undocumented)
      // General IO's
      .status_vector(gmii_status0),    // Core status.
      .signal_detect(1'b1 /*Optical module not supported*/) // Input from PMD to indicate presence of optical input.
   );

   assign eth0_phy_status  = gmii_status0;

`endif // `ifdef ETH10G_PORT0

   //////////////////////////////////////////////////////////////////////
   //
   // Configure Ethernet PHY implemented for PORT1
   //
   //////////////////////////////////////////////////////////////////////
   wire        mdc1, mdio_in1, mdio_out1, mdio_tri1;
   wire [4:0]  prtad1 = 5'b00100;  // MDIO address is 4
   wire [15:0] eth1_phy_status;

`ifdef ETH10G_PORT1
   //////////////////////////////////////////////////////////////////////
   //
   // 10GBaseR PHY with XGMII interface to MAC
   //
   //////////////////////////////////////////////////////////////////////
   wire        xgmii_clk1;  // 156.25MHz
   wire [63:0] xgmii_txd1;
   wire [7:0]  xgmii_txc1;
   wire [63:0] xgmii_rxd1;
   wire [7:0]  xgmii_rxc1;

   wire [7:0]  xgmii_status1;
   wire        xge_phy_resetdone1;

   ten_gige_phy ten_gige_phy_port1
   (
      // Clocks and Reset
      .areset(global_rst | sw_rst[0]), // Asynchronous reset for entire core.
      .refclk(xgige_refclk),           // Transciever reference clock: 156.25MHz
      .clk156(xgige_clk156),           // Globally buffered core clock: 156.25MHz
      .dclk(xgige_dclk),               // Management/DRP clock: 78.125MHz
      .sim_speedup_control(1'b0),
      // GMII Interface (client MAC <=> PCS)
      .xgmii_txd(xgmii_txd1),          // Transmit data from client MAC.
      .xgmii_txc(xgmii_txc1),          // Transmit control signal from client MAC.
      .xgmii_rxd(xgmii_rxd1),          // Received Data to client MAC.
      .xgmii_rxc(xgmii_rxc1),          // Received control signal to client MAC.
      // Tranceiver Interface
      .txp(SFP1_TX_p),                 // Differential +ve of serial transmission from PMA to PMD.
      .txn(SFP1_TX_n),                 // Differential -ve of serial transmission from PMA to PMD.
      .rxp(SFP1_RX_p),                 // Differential +ve for serial reception from PMD to PMA.
      .rxn(SFP1_RX_n),                 // Differential -ve for serial reception from PMD to PMA.
      // Management: MDIO Interface
      .mdc(mdc1),                      // Management Data Clock
      .mdio_in(mdio_in1),              // Management Data In
      .mdio_out(mdio_out1),            // Management Data Out
      .mdio_tri(mdio_tri1),            // Management Data Tristate
      .prtad(prtad0),
      // General IO's
      .core_status(xgmii_status1),     // Core status
      .resetdone(xge_phy_resetdone1),
      .signal_detect(~SFPP1_RxLOS),    // Input from PMD to indicate presence of optical input. (Undocumented, but it seems Xilinx expect this to be inverted.)
      .tx_fault(SFPP1_TxFault),
      .tx_disable(SFPP1_TxDisable)
   );

   assign xgmii_clk1       = xgige_clk156;
   assign eth1_phy_status  = {8'h00, xgmii_status1};

`else

   //////////////////////////////////////////////////////////////////////
   //
   // 1000Base-X PHY with GMII interface to MAC
   //
   //////////////////////////////////////////////////////////////////////
   wire [31:0] gige_phy_misc_dbg1;
   wire [15:0] gige_phy_int_data1;
   wire [7:0]  gmii_txd1, gmii_rxd1;
   wire        gmii_tx_en1, gmii_tx_er1, gmii_rx_dv1, gmii_rx_er1;
   wire        gmii_clk1;
   wire [15:0] gmii_status1;

   assign SFPP1_TxDisable = 1'b0; // Always on.

   one_gige_phy one_gige_phy_port1 
   (
      .reset(global_rst | sw_rst[0]),  // Asynchronous reset for entire core.
      .independent_clock(bus_clk),
      // Tranceiver Interface
      .gtrefclk(gige_refclk),          // Reference clock for MGT: 125MHz, very high quality.
      .txp(SFP1_TX_p),                 // Differential +ve of serial transmission from PMA to PMD.
      .txn(SFP1_TX_n),                 // Differential -ve of serial transmission from PMA to PMD.
      .rxp(SFP1_RX_p),                 // Differential +ve for serial reception from PMD to PMA.
      .rxn(SFP1_RX_n),                 // Differential -ve for serial reception from PMD to PMA.
      // GMII Interface (client MAC <=> PCS)
      .gmii_clk(gmii_clk1),            // Clock to client MAC.
      .gmii_txd(gmii_txd1),            // Transmit data from client MAC.
      .gmii_tx_en(gmii_tx_en1),        // Transmit control signal from client MAC.
      .gmii_tx_er(gmii_tx_er1),        // Transmit control signal from client MAC.
      .gmii_rxd(gmii_rxd1),            // Received Data to client MAC.
      .gmii_rx_dv(gmii_rx_dv1),        // Received control signal to client MAC.
      .gmii_rx_er(gmii_rx_er1),        // Received control signal to client MAC.
      // Management: MDIO Interface
      .mdc(mdc1),                      // Management Data Clock
      .mdio_i(mdio_in1),               // Management Data In
      .mdio_o(mdio_out1),              // Management Data Out
      .mdio_t(mdio_tri1),              // Management Data Tristate
      .configuration_vector(5'd0),     // Alternative to MDIO interface.
      .configuration_valid(1'b1),      // Validation signal for Config vector (MUST be 1 for proper functionality...undocumented)
      // General IO's
      .status_vector(gmii_status1),    // Core status.
      .signal_detect(1'b1 /*Optical module not supported*/) // Input from PMD to indicate presence of optical input.
   );

   assign eth1_phy_status  = gmii_status1;

`endif // `ifdef ETH10G_PORT1

   ///////////////////////////////////////////////////////////////////////////////////
   //
   // Synchronize misc asynchronous signals
   //
   ///////////////////////////////////////////////////////////////////////////////////
   wire LMK_Holdover_sync, LMK_Lock_sync, LMK_Sync_sync;
   wire LMK_Status0_sync, LMK_Status1_sync;

   //Sync all LMK_* signals to bus_clk
   synchronizer #(.INITIAL_VAL(1'b0)) LMK_Holdover_sync_inst (
      .clk(bus_clk), .rst(1'b0 /* no reset */), .in(LMK_Holdover), .out(LMK_Holdover_sync));
   synchronizer #(.INITIAL_VAL(1'b0)) LMK_Lock_sync_inst (
      .clk(bus_clk), .rst(1'b0 /* no reset */), .in(LMK_Lock), .out(LMK_Lock_sync));
   synchronizer #(.INITIAL_VAL(1'b0)) LMK_Sync_sync_inst (
      .clk(bus_clk), .rst(1'b0 /* no reset */), .in(LMK_Sync), .out(LMK_Sync_sync));
   //The status bits (although in a bus) are really independent
   synchronizer #(.INITIAL_VAL(1'b0)) LMK_Status0_sync_inst (
      .clk(bus_clk), .rst(1'b0 /* no reset */), .in(LMK_Status[0]), .out(LMK_Status0_sync));
   synchronizer #(.INITIAL_VAL(1'b0)) LMK_Status1_sync_inst (
      .clk(bus_clk), .rst(1'b0 /* no reset */), .in(LMK_Status[1]), .out(LMK_Status1_sync));


`ifndef NO_DRAM_FIFOS

   ///////////////////////////////////////////////////////////////////////////////////
   //
   // Xilinx DDR3 Controller and PHY.
   //
   ///////////////////////////////////////////////////////////////////////////////////


   wire        ddr3_axi_clk;           // 1/4 DDR external clock rate (250MHz)
   wire        ddr3_axi_clk_x2;        // 1/4 DDR external clock rate (250MHz)
   wire        ddr3_axi_rst;           // Synchronized to ddr_sys_clk
   wire        ddr3_running;           // DRAM calibration complete.

   // Slave Interface Write Address Ports
   wire [3:0]  s_axi_awid;
   wire [31:0] s_axi_awaddr;
   wire [7:0]  s_axi_awlen;
   wire [2:0]  s_axi_awsize;
   wire [1:0]  s_axi_awburst;
   wire [0:0]  s_axi_awlock;
   wire [3:0]  s_axi_awcache;
   wire [2:0]  s_axi_awprot;
   wire [3:0]  s_axi_awqos;
   wire        s_axi_awvalid;
   wire        s_axi_awready;
   // Slave Interface Write Data Ports
   wire [255:0] s_axi_wdata;
   wire [31:0]  s_axi_wstrb;
   wire     s_axi_wlast;
   wire     s_axi_wvalid;
   wire     s_axi_wready;
   // Slave Interface Write Response Ports
   wire     s_axi_bready;
   wire [3:0]   s_axi_bid;
   wire [1:0]   s_axi_bresp;
   wire     s_axi_bvalid;
   // Slave Interface Read Address Ports
   wire [3:0]   s_axi_arid;
   wire [31:0]  s_axi_araddr;
   wire [7:0]   s_axi_arlen;
   wire [2:0]   s_axi_arsize;
   wire [1:0]   s_axi_arburst;
   wire [0:0]   s_axi_arlock;
   wire [3:0]   s_axi_arcache;
   wire [2:0]   s_axi_arprot;
   wire [3:0]   s_axi_arqos;
   wire     s_axi_arvalid;
   wire     s_axi_arready;
   // Slave Interface Read Data Ports
   wire     s_axi_rready;
   wire [3:0]   s_axi_rid;
   wire [255:0] s_axi_rdata;
   wire [1:0]   s_axi_rresp;
   wire     s_axi_rlast;
   wire     s_axi_rvalid;

   reg      ddr3_axi_rst_reg_n;

   // Copied this reset circuit from example design.
   always @(posedge ddr3_axi_clk)
     ddr3_axi_rst_reg_n <= ~ddr3_axi_rst;

   // Instantiate the DDR3 MIG core
   //
   // The top-level IP block has no parameters defined for some reason.
   // Most of configurable parameters are hard-coded in the mig so get 
   // some additional knobs we pull those out into verilog headers.
   //
   // Synthesis params:  ip/ddr3_32bit/ddr3_32bit_mig_parameters.vh
   // Simulation params: ip/ddr3_32bit/ddr3_32bit_mig_sim_parameters.vh

   ddr3_32bit u_ddr3_32bit (
      // Memory interface ports
      .ddr3_addr                      (ddr3_addr),
      .ddr3_ba                        (ddr3_ba),
      .ddr3_cas_n                     (ddr3_cas_n),
      .ddr3_ck_n                      (ddr3_ck_n),
      .ddr3_ck_p                      (ddr3_ck_p),
      .ddr3_cke                       (ddr3_cke),
      .ddr3_ras_n                     (ddr3_ras_n),
      .ddr3_reset_n                   (ddr3_reset_n),
      .ddr3_we_n                      (ddr3_we_n),
      .ddr3_dq                        (ddr3_dq),
      .ddr3_dqs_n                     (ddr3_dqs_n),
      .ddr3_dqs_p                     (ddr3_dqs_p),
      .init_calib_complete            (ddr3_running),

      .ddr3_cs_n                      (ddr3_cs_n),
      .ddr3_dm                        (ddr3_dm),
      .ddr3_odt                       (ddr3_odt),
      // Application interface ports
      .ui_clk                         (ddr3_axi_clk),  // 250MHz clock out
      .ui_clk_x2                      (ddr3_axi_clk_x2),
      .ui_clk_sync_rst                (ddr3_axi_rst),  // Active high Reset signal synchronised to 250MHz
      .aresetn                        (ddr3_axi_rst_reg_n),
      .app_sr_req                     (1'b0),
      .app_sr_active                  (app_sr_active),
      .app_ref_req                    (1'b0),
      .app_ref_ack                    (app_ref_ack),
      .app_zq_req                     (1'b0),
      .app_zq_ack                     (app_zq_ack),

      // Slave Interface Write Address Ports
      .s_axi_awid                     (s_axi_awid),
      .s_axi_awaddr                   (s_axi_awaddr),
      .s_axi_awlen                    (s_axi_awlen),
      .s_axi_awsize                   (s_axi_awsize),
      .s_axi_awburst                  (s_axi_awburst),
      .s_axi_awlock                   (s_axi_awlock),
      .s_axi_awcache                  (s_axi_awcache),
      .s_axi_awprot                   (s_axi_awprot),
      .s_axi_awqos                    (s_axi_awqos),
      .s_axi_awvalid                  (s_axi_awvalid),
      .s_axi_awready                  (s_axi_awready),
      // Slave Interface Write Data Ports
      .s_axi_wdata                    (s_axi_wdata),
      .s_axi_wstrb                    (s_axi_wstrb),
      .s_axi_wlast                    (s_axi_wlast),
      .s_axi_wvalid                   (s_axi_wvalid),
      .s_axi_wready                   (s_axi_wready),
      // Slave Interface Write Response Ports
      .s_axi_bid                      (s_axi_bid),
      .s_axi_bresp                    (s_axi_bresp),
      .s_axi_bvalid                   (s_axi_bvalid),
      .s_axi_bready                   (s_axi_bready),
      // Slave Interface Read Address Ports
      .s_axi_arid                     (s_axi_arid),
      .s_axi_araddr                   (s_axi_araddr),
      .s_axi_arlen                    (s_axi_arlen),
      .s_axi_arsize                   (s_axi_arsize),
      .s_axi_arburst                  (s_axi_arburst),
      .s_axi_arlock                   (s_axi_arlock),
      .s_axi_arcache                  (s_axi_arcache),
      .s_axi_arprot                   (s_axi_arprot),
      .s_axi_arqos                    (s_axi_arqos),
      .s_axi_arvalid                  (s_axi_arvalid),
      .s_axi_arready                  (s_axi_arready),
      // Slave Interface Read Data Ports
      .s_axi_rid                      (s_axi_rid),
      .s_axi_rdata                    (s_axi_rdata),
      .s_axi_rresp                    (s_axi_rresp),
      .s_axi_rlast                    (s_axi_rlast),
      .s_axi_rvalid                   (s_axi_rvalid),
      .s_axi_rready                   (s_axi_rready),
      // System Clock Ports
      .sys_clk_i                      (sys_clk_i),  // From external 100MHz source.
      .sys_rst                        (~global_rst) // IJB. Poorly named active low. Should change RST_ACT_LOW.
   );

`endif //  `ifndef NO_DRAM_FIFOS

   ///////////////////////////////////////////////////////////////////////////////////
   //
   // X300 Core
   //
   ///////////////////////////////////////////////////////////////////////////////////

   x300_core x300_core
     (
      .radio_clk(radio_clk), .radio_rst(radio_rst),
      .bus_clk(bus_clk), .bus_rst(bus_rst), .sw_rst(sw_rst),
`ifdef DEBUG_UART
      .fp_gpio(FrontPanelGpio[9:0]), // Discard upper unsued bits.
`else
      .fp_gpio(FrontPanelGpio[11:0]), // Discard upper unsued bits.
      `endif
      // Radio0 signals
      .rx0(rx0), .tx0(tx0), .db_gpio0({DB0_TX_IO,DB0_RX_IO}),
      .sen0(sen0), .sclk0(sclk0), .mosi0(mosi0), .miso0(miso0),
      .radio_led0(led0), .radio0_misc_out(radio0_misc_out), .radio0_misc_in(radio0_misc_in),
      .sync_dacs_radio0(sync_dacs_radio0),
      // Radio1 signals
      .rx1(rx1), .tx1(tx1), .db_gpio1({DB1_TX_IO,DB1_RX_IO}),
      .sen1(sen1), .sclk1(sclk1), .mosi1(mosi1), .miso1(miso1),
      .radio_led1(led1), .radio1_misc_out(radio1_misc_out), .radio1_misc_in(radio1_misc_in),
      .sync_dacs_radio1(sync_dacs_radio1),
      // I2C bus
      .db_scl(DB_SCL), .db_sda(DB_SDA),
      // External clock gen
      .ext_ref_clk(ref_clk_10mhz),
      .clock_ref_sel(ClockRefSelect),
      .clock_misc_opt({GPSDO_PWR_ENA, TCXO_ENA}),
      .LMK_Status({LMK_Status1_sync, LMK_Status0_sync}), .LMK_Holdover(LMK_Holdover_sync), .LMK_Lock(LMK_Lock_sync), .LMK_Sync(LMK_Sync_sync),
      .LMK_SEN(LMK_SEN), .LMK_SCLK(LMK_SCLK), .LMK_MOSI(LMK_MOSI),
      // SFP+ 0 flags
      .SFPP0_SCL(SFPP0_SCL),
      .SFPP0_SDA(SFPP0_SDA),
      .SFPP0_ModAbs(SFPP0_ModAbs),
      .SFPP0_TxFault(SFPP0_TxFault),
      .SFPP0_RxLOS(SFPP0_RxLOS),
      .SFPP0_RS1(SFPP0_RS1),
      .SFPP0_RS0(SFPP0_RS0),
      // SFP+ 1 flags
      .SFPP1_SCL(SFPP1_SCL),
      .SFPP1_SDA(SFPP1_SDA),
      .SFPP1_ModAbs(SFPP1_ModAbs),
      .SFPP1_TxFault(SFPP1_TxFault),
      .SFPP1_RxLOS(SFPP1_RxLOS),
      .SFPP1_RS1(SFPP1_RS1),
      .SFPP1_RS0(SFPP1_RS0),
      // MDIO bus to SFP0
      .mdc0(mdc0),
      .mdio_in0(mdio_in0),
      .mdio_out0(mdio_out0),
      .eth0_phy_status(eth0_phy_status),
      // SFP+ 0 packet interface
`ifdef ETH10G_PORT0
      .xgmii_clk0(xgmii_clk0),
      .xgmii_txd0(xgmii_txd0),
      .xgmii_txc0(xgmii_txc0),
      .xgmii_rxd0(xgmii_rxd0),
      .xgmii_rxc0(xgmii_rxc0),
      .xge_phy_resetdone0(xge_phy_resetdone0),
`else
      .gmii_clk0(gmii_clk0),
      .gmii_txd0(gmii_txd0), .gmii_tx_en0(gmii_tx_en0), .gmii_tx_er0(gmii_tx_er0),
      .gmii_rxd0(gmii_rxd0), .gmii_rx_dv0(gmii_rx_dv0), .gmii_rx_er0(gmii_rx_er0),
`endif // !`ifdef
      // MDIO bus to SFP1
      .mdc1(mdc1),
      .mdio_in1(mdio_in1),
      .mdio_out1(mdio_out1),
      .eth1_phy_status(eth1_phy_status),
      // SFP+ 1 packet interface
`ifdef ETH10G_PORT1
      .xgmii_clk1(xgmii_clk1),
      .xgmii_txd1(xgmii_txd1),
      .xgmii_txc1(xgmii_txc1),
      .xgmii_rxd1(xgmii_rxd1),
      .xgmii_rxc1(xgmii_rxc1),
      .xge_phy_resetdone1(xge_phy_resetdone1),
`else
      .gmii_clk1(gmii_clk1),
      .gmii_txd1(gmii_txd1), .gmii_tx_en1(gmii_tx_en1), .gmii_tx_er1(gmii_tx_er1),
      .gmii_rxd1(gmii_rxd1), .gmii_rx_dv1(gmii_rx_dv1), .gmii_rx_er1(gmii_rx_er1),
`endif // !`ifdef
      // Time
      .pps(pps),.pps_select(pps_select), .pps_out_enb(pps_out_enb),
      // GPS Signals
      .gps_txd(GPS_SER_IN), .gps_rxd(GPS_SER_OUT),
      // Debug UART
      .debug_rxd(debug_rxd), .debug_txd(debug_txd),
      // Misc.
      .led_misc(leds),
      .debug0(), .debug1(), .debug2(),
`ifndef NO_DRAM_FIFOS
      // DRAM signals.
      .ddr3_axi_clk              (ddr3_axi_clk),
      .ddr3_axi_clk_x2           (ddr3_axi_clk_x2),
      .ddr3_axi_rst              (ddr3_axi_rst),
      .ddr3_running              (ddr3_running),
      // Slave Interface Write Address Ports
      .ddr3_axi_awid             (s_axi_awid),
      .ddr3_axi_awaddr           (s_axi_awaddr),
      .ddr3_axi_awlen            (s_axi_awlen),
      .ddr3_axi_awsize           (s_axi_awsize),
      .ddr3_axi_awburst          (s_axi_awburst),
      .ddr3_axi_awlock           (s_axi_awlock),
      .ddr3_axi_awcache          (s_axi_awcache),
      .ddr3_axi_awprot           (s_axi_awprot),
      .ddr3_axi_awqos            (s_axi_awqos),
      .ddr3_axi_awvalid          (s_axi_awvalid),
      .ddr3_axi_awready          (s_axi_awready),
      // Slave Interface Write Data Ports
      .ddr3_axi_wdata            (s_axi_wdata),
      .ddr3_axi_wstrb            (s_axi_wstrb),
      .ddr3_axi_wlast            (s_axi_wlast),
      .ddr3_axi_wvalid           (s_axi_wvalid),
      .ddr3_axi_wready           (s_axi_wready),
      // Slave Interface Write Response Ports
      .ddr3_axi_bid              (s_axi_bid),
      .ddr3_axi_bresp            (s_axi_bresp),
      .ddr3_axi_bvalid           (s_axi_bvalid),
      .ddr3_axi_bready           (s_axi_bready),
      // Slave Interface Read Address Ports
      .ddr3_axi_arid             (s_axi_arid),
      .ddr3_axi_araddr           (s_axi_araddr),
      .ddr3_axi_arlen            (s_axi_arlen),
      .ddr3_axi_arsize           (s_axi_arsize),
      .ddr3_axi_arburst          (s_axi_arburst),
      .ddr3_axi_arlock           (s_axi_arlock),
      .ddr3_axi_arcache          (s_axi_arcache),
      .ddr3_axi_arprot           (s_axi_arprot),
      .ddr3_axi_arqos            (s_axi_arqos),
      .ddr3_axi_arvalid          (s_axi_arvalid),
      .ddr3_axi_arready          (s_axi_arready),
      // Slave Interface Read Data Ports
      .ddr3_axi_rid              (s_axi_rid),
      .ddr3_axi_rdata            (s_axi_rdata),
      .ddr3_axi_rresp            (s_axi_rresp),
      .ddr3_axi_rlast            (s_axi_rlast),
      .ddr3_axi_rvalid           (s_axi_rvalid),
      .ddr3_axi_rready           (s_axi_rready),
`endif //  `ifndef NO_DRAM_FIFOS

      // IoPort2 Message FIFOs
      .o_iop2_msg_tdata          (o_iop2_msg_tdata),
      .o_iop2_msg_tvalid         (o_iop2_msg_tvalid),
      .o_iop2_msg_tlast          (o_iop2_msg_tlast),
      .o_iop2_msg_tready         (o_iop2_msg_tready),
      .i_iop2_msg_tdata          (i_iop2_msg_tdata),
      .i_iop2_msg_tvalid         (i_iop2_msg_tvalid),
      .i_iop2_msg_tlast          (i_iop2_msg_tlast),
      .i_iop2_msg_tready         (i_iop2_msg_tready),
      // PCIe DMA Data
      .pcio_tdata                (pcio_tdata),
      .pcio_tlast                (pcio_tlast),
      .pcio_tvalid               (pcio_tvalid),
      .pcio_tready               (pcio_tready),
      .pcii_tdata                (pcii_tdata),
      .pcii_tlast                (pcii_tlast),
      .pcii_tvalid               (pcii_tvalid),
      .pcii_tready               (pcii_tready)
   );
   
   assign {DB_ADC_RESET, DB_DAC_RESET,DB0_DAC_ENABLE} = radio0_misc_out[2:0];
   assign {DB1_DAC_ENABLE}                            = radio1_misc_out[0];   //[2:1] unused

   /////////////////////////////////////////////////////////////////////
   //
   // PUDC Workaround
   //
   //////////////////////////////////////////////////////////////////////
   // This is a workaround for a silicon bug in Series 7 FPGA where a
   // race condition with the reading of PUDC during the erase of the FPGA
   // image cause glitches on output IO pins. This glitch happens even if 
   // you have PUDC correctly pulled high!!  When PUDC is high the pull up 
   // resistor should never be enabled on the IO lines, however there is a
   // race condition that causes this to not be the case.
   //
   // Workaround:
   // - Define the PUDC pin in the XDC file with a pullup.
   // - Implements an IBUF on the PUDC input and make sure that it does 
   //   not get optimized out.
   (* dont_touch = "true" *) wire fpga_pudc_b_buf;
   IBUF pudc_ibuf_i (
      .I(FPGA_PUDC_B),
      .O(fpga_pudc_b_buf));

endmodule // x300
