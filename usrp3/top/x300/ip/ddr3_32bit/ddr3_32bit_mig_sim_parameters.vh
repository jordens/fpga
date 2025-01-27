//***************************************************************************
// X3x0 DDR3 MIG SIMULATION PARAMETERS 
// 
// Included in ddr3_32bit_mig_sim.v
//***************************************************************************

//***************************************************************************
// The following parameters refer to width of various ports
//***************************************************************************
parameter BANK_WIDTH            = 3,
                                  // # of memory Bank Address bits.
parameter CK_WIDTH              = 1,
                                  // # of CK/CK# outputs to memory.
parameter COL_WIDTH             = 10,
                                  // # of memory Column Address bits.
parameter CS_WIDTH              = 1,
                                  // # of unique CS outputs to memory.
parameter nCS_PER_RANK          = 1,
                                  // # of unique CS outputs per rank for phy
parameter CKE_WIDTH             = 1,
                                  // # of CKE outputs to memory.
parameter DATA_BUF_ADDR_WIDTH   = 5,
parameter DQ_CNT_WIDTH          = 5,
                                  // = ceil(log2(DQ_WIDTH))
parameter DQ_PER_DM             = 8,
parameter DM_WIDTH              = 4,
                                  // # of DM (data mask)
parameter DQ_WIDTH              = 32,
                                  // # of DQ (data)
parameter DQS_WIDTH             = 4,
parameter DQS_CNT_WIDTH         = 2,
                                  // = ceil(log2(DQS_WIDTH))
parameter DRAM_WIDTH            = 8,
                                  // # of DQ per DQS
parameter ECC                   = "OFF",
parameter DATA_WIDTH            = 32,
parameter ECC_TEST              = "OFF",
parameter PAYLOAD_WIDTH         = (ECC_TEST == "OFF") ? DATA_WIDTH : DQ_WIDTH,
parameter MEM_ADDR_ORDER        = "BANK_ROW_COLUMN",
                                   //Possible Parameters
                                   //1.BANK_ROW_COLUMN : Address mapping is
                                   //                    in form of Bank Row Column.
                                   //2.ROW_BANK_COLUMN : Address mapping is
                                   //                    in the form of Row Bank Column.
                                   //3.TG_TEST : Scrambles Address bits
                                   //            for distributed Addressing.
   
parameter nBANK_MACHS           = 4,
parameter RANKS                 = 1,
                                  // # of Ranks.
parameter ODT_WIDTH             = 1,
                                  // # of ODT outputs to memory.
parameter ROW_WIDTH             = 15,
                                  // # of memory Row Address bits.
parameter ADDR_WIDTH            = 29,
                                  // # = RANK_WIDTH + BANK_WIDTH
                                  //     + ROW_WIDTH + COL_WIDTH;
                                  // Chip Select is always tied to low for
                                  // single rank devices
parameter USE_CS_PORT          = 1,
                                  // # = 1, When Chip Select (CS#) output is enabled
                                  //   = 0, When Chip Select (CS#) output is disabled
                                  // If CS_N disabled, user must connect
                                  // DRAM CS_N input(s) to ground
parameter USE_DM_PORT           = 1,
                                  // # = 1, When Data Mask option is enabled
                                  //   = 0, When Data Mask option is disbaled
                                  // When Data Mask option is disabled in
                                  // MIG Controller Options page, the logic
                                  // related to Data Mask should not get
                                  // synthesized
parameter USE_ODT_PORT          = 1,
                                  // # = 1, When ODT output is enabled
                                  //   = 0, When ODT output is disabled
                                  // Parameter configuration for Dynamic ODT support:
                                  // USE_ODT_PORT = 0, RTT_NOM = "DISABLED", RTT_WR = "60/120".
                                  // This configuration allows to save ODT pin mapping from FPGA.
                                  // The user can tie the ODT input of DRAM to HIGH.
parameter IS_CLK_SHARED          = "FALSE",
                                   // # = "true" when clock is shared
                                   //   = "false" when clock is not shared

parameter PHY_CONTROL_MASTER_BANK = 1,
                                  // The bank index where master PHY_CONTROL resides,
                                  // equal to the PLL residing bank
parameter MEM_DENSITY           = "4Gb",
                                  // Indicates the density of the Memory part
                                  // Added for the sake of Vivado simulations
parameter MEM_SPEEDGRADE        = "125",
                                  // Indicates the Speed grade of Memory Part
                                  // Added for the sake of Vivado simulations
parameter MEM_DEVICE_WIDTH      = 16,
                                  // Indicates the device width of the Memory Part
                                  // Added for the sake of Vivado simulations

//***************************************************************************
// The following parameters are mode register settings
//***************************************************************************
parameter AL                    = "0",
                                  // DDR3 SDRAM:
                                  // Additive Latency (Mode Register 1).
                                  // # = "0", "CL-1", "CL-2".
                                  // DDR2 SDRAM:
                                  // Additive Latency (Extended Mode Register).
parameter nAL                   = 0,
                                  // # Additive Latency in number of clock
                                  // cycles.
parameter BURST_MODE            = "8",
                                  // DDR3 SDRAM:
                                  // Burst Length (Mode Register 0).
                                  // # = "8", "4", "OTF".
                                  // DDR2 SDRAM:
                                  // Burst Length (Mode Register).
                                  // # = "8", "4".
parameter BURST_TYPE            = "SEQ",
                                  // DDR3 SDRAM: Burst Type (Mode Register 0).
                                  // DDR2 SDRAM: Burst Type (Mode Register).
                                  // # = "SEQ" - (Sequential),
                                  //   = "INT" - (Interleaved).
parameter CL                    = 9,
                                  // in number of clock cycles
                                  // DDR3 SDRAM: CAS Latency (Mode Register 0).
                                  // DDR2 SDRAM: CAS Latency (Mode Register).
parameter CWL                   = 7,
                                  // in number of clock cycles
                                  // DDR3 SDRAM: CAS Write Latency (Mode Register 2).
                                  // DDR2 SDRAM: Can be ignored
parameter OUTPUT_DRV            = "HIGH",
                                  // Output Driver Impedance Control (Mode Register 1).
                                  // # = "HIGH" - RZQ/7,
                                  //   = "LOW" - RZQ/6.
parameter RTT_NOM               = "60",
                                  // RTT_NOM (ODT) (Mode Register 1).
                                  //   = "120" - RZQ/2,
                                  //   = "60"  - RZQ/4,
                                  //   = "40"  - RZQ/6.
parameter RTT_WR                = "OFF",
                                  // RTT_WR (ODT) (Mode Register 2).
                                  // # = "OFF" - Dynamic ODT off,
                                  //   = "120" - RZQ/2,
                                  //   = "60"  - RZQ/4,
parameter ADDR_CMD_MODE         = "1T" ,
                                  // # = "1T", "2T".
parameter REG_CTRL              = "OFF",
                                  // # = "ON" - RDIMMs,
                                  //   = "OFF" - Components, SODIMMs, UDIMMs.
parameter CA_MIRROR             = "OFF",
                                  // C/A mirror opt for DDR3 dual rank

parameter VDD_OP_VOLT           = "150",
                                  // # = "150" - 1.5V Vdd Memory part
                                  //   = "135" - 1.35V Vdd Memory part


//***************************************************************************
// The following parameters are multiplier and divisor factors for PLLE2.
// Based on the selected design frequency these parameters vary.
//***************************************************************************
parameter CLKIN_PERIOD          = 9996,
                                  // Input Clock Period
parameter CLKFBOUT_MULT         = 12,
                                  // write PLL VCO multiplier
parameter DIVCLK_DIVIDE         = 1,
                                  // write PLL VCO divisor
parameter CLKOUT0_PHASE         = 337.5,
                                  // Phase for PLL output clock (CLKOUT0)
parameter CLKOUT0_DIVIDE        = 2,
                                  // VCO output divisor for PLL output clock (CLKOUT0)
parameter CLKOUT1_DIVIDE        = 2,
                                  // VCO output divisor for PLL output clock (CLKOUT1)
parameter CLKOUT2_DIVIDE        = 32,
                                  // VCO output divisor for PLL output clock (CLKOUT2)
parameter CLKOUT3_DIVIDE        = 8,
                                  // VCO output divisor for PLL output clock (CLKOUT3)
parameter CLKOUT5_DIVIDE        = 6,
                                  // VCO output divisor for PLL output clock (CLKOUT5)
parameter MMCM_VCO              = 1200,
                                  // Max Freq (MHz) of MMCM VCO
parameter MMCM_MULT_F           = 8,
                                  // write MMCM VCO multiplier
parameter MMCM_DIVCLK_DIVIDE    = 1,
                                  // write MMCM VCO divisor

//***************************************************************************
// Memory Timing Parameters. These parameters varies based on the selected
// memory part.
//***************************************************************************
parameter tCKE                  = 5000,
                                  // memory tCKE paramter in pS
parameter tFAW                  = 30000,
                                  // memory tRAW paramter in pS.
parameter tPRDI                 = 1_000_000,
                                  // memory tPRDI paramter in pS.
parameter tRAS                  = 35000,
                                  // memory tRAS paramter in pS.
parameter tRCD                  = 13750,
                                  // memory tRCD paramter in pS.
parameter tREFI                 = 7800000,
                                  // memory tREFI paramter in pS.
parameter tRFC                  = 260000,
                                  // memory tRFC paramter in pS.
parameter tRP                   = 13750,
                                  // memory tRP paramter in pS.
parameter tRRD                  = 6000,
                                  // memory tRRD paramter in pS.
parameter tRTP                  = 7500,
                                  // memory tRTP paramter in pS.
parameter tWTR                  = 7500,
                                  // memory tWTR paramter in pS.
parameter tZQI                  = 128_000_000,
                                  // memory tZQI paramter in nS.
parameter tZQCS                 = 64,
                                  // memory tZQCS paramter in clock cycles.

//***************************************************************************
// Simulation parameters
//***************************************************************************
parameter SIM_BYPASS_INIT_CAL   = "FAST",
                                  // # = "OFF" -  Complete memory init &
                                  //              calibration sequence
                                  // # = "SKIP" - Not supported
                                  // # = "FAST" - Complete memory init & use
                                  //              abbreviated calib sequence

parameter SIMULATION            = "TRUE",
                                  // Should be TRUE during design simulations and
                                  // FALSE during implementations

//***************************************************************************
// The following parameters varies based on the pin out entered in MIG GUI.
// Do not change any of these parameters directly by editing the RTL.
// Any changes required should be done through GUI and the design regenerated.
//***************************************************************************
parameter BYTE_LANES_B0         = 4'b1111,
                                  // Byte lanes used in an IO column.
parameter BYTE_LANES_B1         = 4'b1110,
                                  // Byte lanes used in an IO column.
parameter BYTE_LANES_B2         = 4'b0000,
                                  // Byte lanes used in an IO column.
parameter BYTE_LANES_B3         = 4'b0000,
                                  // Byte lanes used in an IO column.
parameter BYTE_LANES_B4         = 4'b0000,
                                  // Byte lanes used in an IO column.
parameter DATA_CTL_B0           = 4'b1111,
                                  // Indicates Byte lane is data byte lane
                                  // or control Byte lane. '1' in a bit
                                  // position indicates a data byte lane and
                                  // a '0' indicates a control byte lane
parameter DATA_CTL_B1           = 4'b0000,
                                  // Indicates Byte lane is data byte lane
                                  // or control Byte lane. '1' in a bit
                                  // position indicates a data byte lane and
                                  // a '0' indicates a control byte lane
parameter DATA_CTL_B2           = 4'b0000,
                                  // Indicates Byte lane is data byte lane
                                  // or control Byte lane. '1' in a bit
                                  // position indicates a data byte lane and
                                  // a '0' indicates a control byte lane
parameter DATA_CTL_B3           = 4'b0000,
                                  // Indicates Byte lane is data byte lane
                                  // or control Byte lane. '1' in a bit
                                  // position indicates a data byte lane and
                                  // a '0' indicates a control byte lane
parameter DATA_CTL_B4           = 4'b0000,
                                  // Indicates Byte lane is data byte lane
                                  // or control Byte lane. '1' in a bit
                                  // position indicates a data byte lane and
                                  // a '0' indicates a control byte lane
parameter PHY_0_BITLANES        = 48'h3FE_3FE_3FE_2FF,
parameter PHY_1_BITLANES        = 48'h3FF_FFF_C00_000,
parameter PHY_2_BITLANES        = 48'h000_000_000_000,

// control/address/data pin mapping parameters
parameter CK_BYTE_MAP
  = 144'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_13,
parameter ADDR_MAP
  = 192'h000_139_138_137_136_135_134_133_132_131_130_129_128_127_126_12B,
parameter BANK_MAP   = 36'h12A_125_124,
parameter CAS_MAP    = 12'h122,
parameter CKE_ODT_BYTE_MAP = 8'h00,
parameter CKE_MAP    = 96'h000_000_000_000_000_000_000_11B,
parameter ODT_MAP    = 96'h000_000_000_000_000_000_000_11A,
parameter CS_MAP     = 120'h000_000_000_000_000_000_000_000_000_120,
parameter PARITY_MAP = 12'h000,
parameter RAS_MAP    = 12'h123,
parameter WE_MAP     = 12'h121,
parameter DQS_BYTE_MAP
  = 144'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_01_02_03,
parameter DATA0_MAP  = 96'h031_032_033_034_035_036_037_038,
parameter DATA1_MAP  = 96'h021_022_023_024_025_026_027_028,
parameter DATA2_MAP  = 96'h011_012_013_014_015_016_017_018,
parameter DATA3_MAP  = 96'h000_001_002_003_004_005_006_007,
parameter DATA4_MAP  = 96'h000_000_000_000_000_000_000_000,
parameter DATA5_MAP  = 96'h000_000_000_000_000_000_000_000,
parameter DATA6_MAP  = 96'h000_000_000_000_000_000_000_000,
parameter DATA7_MAP  = 96'h000_000_000_000_000_000_000_000,
parameter DATA8_MAP  = 96'h000_000_000_000_000_000_000_000,
parameter DATA9_MAP  = 96'h000_000_000_000_000_000_000_000,
parameter DATA10_MAP = 96'h000_000_000_000_000_000_000_000,
parameter DATA11_MAP = 96'h000_000_000_000_000_000_000_000,
parameter DATA12_MAP = 96'h000_000_000_000_000_000_000_000,
parameter DATA13_MAP = 96'h000_000_000_000_000_000_000_000,
parameter DATA14_MAP = 96'h000_000_000_000_000_000_000_000,
parameter DATA15_MAP = 96'h000_000_000_000_000_000_000_000,
parameter DATA16_MAP = 96'h000_000_000_000_000_000_000_000,
parameter DATA17_MAP = 96'h000_000_000_000_000_000_000_000,
parameter MASK0_MAP  = 108'h000_000_000_000_000_009_019_029_039,
parameter MASK1_MAP  = 108'h000_000_000_000_000_000_000_000_000,

parameter SLOT_0_CONFIG         = 8'b0000_0001,
                                  // Mapping of Ranks.
parameter SLOT_1_CONFIG         = 8'b0000_0000,
                                  // Mapping of Ranks.

//***************************************************************************
// IODELAY and PHY related parameters
//***************************************************************************
parameter IBUF_LPWR_MODE        = "OFF",
                                  // to phy_top
parameter DATA_IO_IDLE_PWRDWN   = "ON",
                                  // # = "ON", "OFF"
parameter BANK_TYPE             = "HP_IO",
                                  // # = "HP_IO", "HPL_IO", "HR_IO", "HRL_IO"
parameter DATA_IO_PRIM_TYPE     = "HP_LP",
                                  // # = "HP_LP", "HR_LP", "DEFAULT"
parameter CKE_ODT_AUX           = "FALSE",
parameter USER_REFRESH          = "OFF",
parameter WRLVL                 = "ON",
                                  // # = "ON" - DDR3 SDRAM
                                  //   = "OFF" - DDR2 SDRAM.
parameter ORDERING              = "NORM",
                                  // # = "NORM", "STRICT", "RELAXED".
parameter CALIB_ROW_ADD         = 16'h0000,
                                  // Calibration row address will be used for
                                  // calibration read and write operations
parameter CALIB_COL_ADD         = 12'h000,
                                  // Calibration column address will be used for
                                  // calibration read and write operations
parameter CALIB_BA_ADD          = 3'h0,
                                  // Calibration bank address will be used for
                                  // calibration read and write operations
parameter TCQ                   = 100,
parameter IDELAY_ADJ            = "OFF",
parameter FINE_PER_BIT          = "OFF",
parameter CENTER_COMP_MODE      = "OFF",
parameter PI_VAL_ADJ            = "OFF",
parameter IODELAY_GRP0          = "DDR3_32BIT_IODELAY_MIG0",
                                  // It is associated to a set of IODELAYs with
                                  // an IDELAYCTRL that have same IODELAY CONTROLLER
                                  // clock frequency (200MHz).
parameter IODELAY_GRP1          = "DDR3_32BIT_IODELAY_MIG1",
                                  // It is associated to a set of IODELAYs with
                                  // an IDELAYCTRL that have same IODELAY CONTROLLER
                                  // clock frequency (300MHz/400MHz).
parameter SYSCLK_TYPE           = "SINGLE_ENDED",
                                  // System clock type DIFFERENTIAL, SINGLE_ENDED,
                                  // NO_BUFFER
parameter REFCLK_TYPE           = "NO_BUFFER",
                                  // Reference clock type DIFFERENTIAL, SINGLE_ENDED,
                                  // NO_BUFFER, USE_SYSTEM_CLOCK
parameter SYS_RST_PORT          = "FALSE",
                                  // "TRUE" - if pin is selected for sys_rst
                                  //          and IBUF will be instantiated.
                                  // "FALSE" - if pin is not selected for sys_rst
parameter FPGA_SPEED_GRADE      = 2,
                                  // FPGA speed grade
   
parameter CMD_PIPE_PLUS1        = "ON",
                                  // add pipeline stage between MC and PHY
parameter DRAM_TYPE             = "DDR3",
parameter CAL_WIDTH             = "HALF",
parameter STARVE_LIMIT          = 2,
                                  // # = 2,3,4.
parameter REF_CLK_MMCM_IODELAY_CTRL    = "FALSE",

//***************************************************************************
// Referece clock frequency parameters
//***************************************************************************
parameter REFCLK_FREQ           = 200.0,
                                  // IODELAYCTRL reference clock frequency
parameter DIFF_TERM_REFCLK      = "TRUE",
                                  // Differential Termination for idelay
                                  // reference clock input pins
//***************************************************************************
// System clock frequency parameters
//***************************************************************************
parameter tCK                   = 1666,
                                  // memory tCK paramter.
                                  // # = Clock Period in pS.
parameter nCK_PER_CLK           = 4,
                                  // # of memory CKs per fabric CLK
parameter DIFF_TERM_SYSCLK      = "TRUE",
                                  // Differential Termination for System
                                  // clock input pins


//***************************************************************************
// AXI4 Shim parameters
//***************************************************************************

parameter UI_EXTRA_CLOCKS = "TRUE",
                                  // Generates extra clocks as
                                  // 1/2, 1/4 and 1/8 of fabrick clock.
                                  // Valid for DDR2/DDR3 AXI interfaces
                                  // based on GUI selection
parameter C_S_AXI_ID_WIDTH              = 4,
                                          // Width of all master and slave ID signals.
                                          // # = >= 1.
parameter C_S_AXI_MEM_SIZE              = "1073741824",
                                  // Address Space required for this component
parameter C_S_AXI_ADDR_WIDTH            = 30,
                                          // Width of S_AXI_AWADDR, S_AXI_ARADDR, M_AXI_AWADDR and
                                          // M_AXI_ARADDR for all SI/MI slots.
                                          // # = 32.
parameter C_S_AXI_DATA_WIDTH            = 256,
                                          // Width of WDATA and RDATA on SI slot.
                                          // Must be <= APP_DATA_WIDTH.
                                          // # = 32, 64, 128, 256.
parameter C_MC_nCK_PER_CLK              = 4,
                                          // Indicates whether to instatiate upsizer
                                          // Range: 0, 1
parameter C_S_AXI_SUPPORTS_NARROW_BURST = 1,
                                          // Indicates whether to instatiate upsizer
                                          // Range: 0, 1
parameter C_RD_WR_ARB_ALGORITHM          = "ROUND_ROBIN",
                                          // Indicates the Arbitration
                                          // Allowed values - "TDM", "ROUND_ROBIN",
                                          // "RD_PRI_REG", "RD_PRI_REG_STARVE_LIMIT"
                                          // "WRITE_PRIORITY", "WRITE_PRIORITY_REG"
parameter C_S_AXI_REG_EN0               = 20'h00000,
                                          // C_S_AXI_REG_EN0[00] = Reserved
                                          // C_S_AXI_REG_EN0[04] = AW CHANNEL REGISTER SLICE
                                          // C_S_AXI_REG_EN0[05] =  W CHANNEL REGISTER SLICE
                                          // C_S_AXI_REG_EN0[06] =  B CHANNEL REGISTER SLICE
                                          // C_S_AXI_REG_EN0[07] =  R CHANNEL REGISTER SLICE
                                          // C_S_AXI_REG_EN0[08] = AW CHANNEL UPSIZER REGISTER SLICE
                                          // C_S_AXI_REG_EN0[09] =  W CHANNEL UPSIZER REGISTER SLICE
                                          // C_S_AXI_REG_EN0[10] = AR CHANNEL UPSIZER REGISTER SLICE
                                          // C_S_AXI_REG_EN0[11] =  R CHANNEL UPSIZER REGISTER SLICE
parameter C_S_AXI_REG_EN1               = 20'h00000,
                                          // Instatiates register slices after the upsizer.
                                          // The type of register is specified for each channel
                                          // in a vector. 4 bits per channel are used.
                                          // C_S_AXI_REG_EN1[03:00] = AW CHANNEL REGISTER SLICE
                                          // C_S_AXI_REG_EN1[07:04] =  W CHANNEL REGISTER SLICE
                                          // C_S_AXI_REG_EN1[11:08] =  B CHANNEL REGISTER SLICE
                                          // C_S_AXI_REG_EN1[15:12] = AR CHANNEL REGISTER SLICE
                                          // C_S_AXI_REG_EN1[20:16] =  R CHANNEL REGISTER SLICE
                                          // Possible values for each channel are:
                                          //
                                          //   0 => BYPASS    = The channel is just wired through the
                                          //                    module.
                                          //   1 => FWD       = The master VALID and payload signals
                                          //                    are registrated.
                                          //   2 => REV       = The slave ready signal is registrated
                                          //   3 => FWD_REV   = Both FWD and REV
                                          //   4 => SLAVE_FWD = All slave side signals and master
                                          //                    VALID and payload are registrated.
                                          //   5 => SLAVE_RDY = All slave side signals and master
                                          //                    READY are registrated.
                                          //   6 => INPUTS    = Slave and Master side inputs are
                                          //                    registrated.
                                          //   7 => ADDRESS   = Optimized for address channel
parameter C_S_AXI_CTRL_ADDR_WIDTH       = 32,
                                          // Width of AXI-4-Lite address bus
parameter C_S_AXI_CTRL_DATA_WIDTH       = 32,
                                          // Width of AXI-4-Lite data buses
parameter C_S_AXI_BASEADDR              = 32'h0000_0000,
                                          // Base address of AXI4 Memory Mapped bus.
parameter C_ECC_ONOFF_RESET_VALUE       = 1,
                                          // Controls ECC on/off value at startup/reset
parameter C_ECC_CE_COUNTER_WIDTH        = 8,
                                          // The external memory to controller clock ratio.

//***************************************************************************
// Debug parameters
//***************************************************************************
parameter DEBUG_PORT            = "OFF",
                                  // # = "ON" Enable debug signals/controls.
                                  //   = "OFF" Disable debug signals/controls.

//***************************************************************************
// Temparature monitor parameter
//***************************************************************************
parameter TEMP_MON_CONTROL      = "INTERNAL",
                                  // # = "INTERNAL", "EXTERNAL"

parameter RST_ACT_LOW           = 1
                                  // =1 for active low reset,
                                  // =0 for active high.
