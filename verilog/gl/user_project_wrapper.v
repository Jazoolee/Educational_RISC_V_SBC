module user_project_wrapper (user_clock2,
    vccd1,
    vccd2,
    vdda1,
    vdda2,
    vssa1,
    vssa2,
    vssd1,
    vssd2,
    wb_clk_i,
    wb_rst_i,
    wbs_ack_o,
    wbs_cyc_i,
    wbs_stb_i,
    wbs_we_i,
    analog_io,
    io_in,
    io_oeb,
    io_out,
    la_data_in,
    la_data_out,
    la_oenb,
    user_irq,
    wbs_adr_i,
    wbs_dat_i,
    wbs_dat_o,
    wbs_sel_i);
 input user_clock2;
 input vccd1;
 input vccd2;
 input vdda1;
 input vdda2;
 input vssa1;
 input vssa2;
 input vssd1;
 input vssd2;
 input wb_clk_i;
 input wb_rst_i;
 output wbs_ack_o;
 input wbs_cyc_i;
 input wbs_stb_i;
 input wbs_we_i;
 inout [28:0] analog_io;
 input [37:0] io_in;
 output [37:0] io_oeb;
 output [37:0] io_out;
 input [127:0] la_data_in;
 output [127:0] la_data_out;
 input [127:0] la_oenb;
 output [2:0] user_irq;
 input [31:0] wbs_adr_i;
 input [31:0] wbs_dat_i;
 output [31:0] wbs_dat_o;
 input [3:0] wbs_sel_i;

 wire csb;
 wire \insMemAddrP2M[0] ;
 wire \insMemAddrP2M[1] ;
 wire \insMemAddrP2M[2] ;
 wire \insMemAddrP2M[3] ;
 wire \insMemAddrP2M[4] ;
 wire \insMemAddrP2M[5] ;
 wire \insMemAddrP2M[6] ;
 wire \insMemAddrP2M[7] ;
 wire \insMemAddrP2M[8] ;
 wire \insMemDataM2P[0] ;
 wire \insMemDataM2P[10] ;
 wire \insMemDataM2P[11] ;
 wire \insMemDataM2P[12] ;
 wire \insMemDataM2P[13] ;
 wire \insMemDataM2P[14] ;
 wire \insMemDataM2P[15] ;
 wire \insMemDataM2P[16] ;
 wire \insMemDataM2P[17] ;
 wire \insMemDataM2P[18] ;
 wire \insMemDataM2P[19] ;
 wire \insMemDataM2P[1] ;
 wire \insMemDataM2P[20] ;
 wire \insMemDataM2P[21] ;
 wire \insMemDataM2P[22] ;
 wire \insMemDataM2P[23] ;
 wire \insMemDataM2P[24] ;
 wire \insMemDataM2P[25] ;
 wire \insMemDataM2P[26] ;
 wire \insMemDataM2P[27] ;
 wire \insMemDataM2P[28] ;
 wire \insMemDataM2P[29] ;
 wire \insMemDataM2P[2] ;
 wire \insMemDataM2P[30] ;
 wire \insMemDataM2P[31] ;
 wire \insMemDataM2P[3] ;
 wire \insMemDataM2P[4] ;
 wire \insMemDataM2P[5] ;
 wire \insMemDataM2P[6] ;
 wire \insMemDataM2P[7] ;
 wire \insMemDataM2P[8] ;
 wire \insMemDataM2P[9] ;
 wire \wmask[0] ;
 wire \wmask[1] ;
 wire \wmask[2] ;
 wire \wmask[3] ;

 SLRV SLRV_CORE (.csb(csb),
    .insMemEn(la_data_in[3]),
    .pc_led(io_out[8]),
    .pc_led_oeb(io_oeb[8]),
    .reset(la_data_in[0]),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .wb_clk_i(wb_clk_i),
    .a7({la_data_out[63],
    la_data_out[62],
    la_data_out[61],
    la_data_out[60],
    la_data_out[59],
    la_data_out[58],
    la_data_out[57],
    la_data_out[56],
    la_data_out[55],
    la_data_out[54],
    la_data_out[53],
    la_data_out[52],
    la_data_out[51],
    la_data_out[50],
    la_data_out[49],
    la_data_out[48],
    la_data_out[47],
    la_data_out[46],
    la_data_out[45],
    la_data_out[44],
    la_data_out[43],
    la_data_out[42],
    la_data_out[41],
    la_data_out[40],
    la_data_out[39],
    la_data_out[38],
    la_data_out[37],
    la_data_out[36],
    la_data_out[35],
    la_data_out[34],
    la_data_out[33],
    la_data_out[32]}),
    .gp({la_data_out[31],
    la_data_out[30],
    la_data_out[29],
    la_data_out[28],
    la_data_out[27],
    la_data_out[26],
    la_data_out[25],
    la_data_out[24],
    la_data_out[23],
    la_data_out[22],
    la_data_out[21],
    la_data_out[20],
    la_data_out[19],
    la_data_out[18],
    la_data_out[17],
    la_data_out[16],
    la_data_out[15],
    la_data_out[14],
    la_data_out[13],
    la_data_out[12],
    la_data_out[11],
    la_data_out[10],
    la_data_out[9],
    la_data_out[8],
    la_data_out[7],
    la_data_out[6],
    la_data_out[5],
    la_data_out[4],
    la_data_out[3],
    la_data_out[2],
    la_data_out[1],
    la_data_out[0]}),
    .insMemAddr({\insMemAddrP2M[8] ,
    \insMemAddrP2M[7] ,
    \insMemAddrP2M[6] ,
    \insMemAddrP2M[5] ,
    \insMemAddrP2M[4] ,
    \insMemAddrP2M[3] ,
    \insMemAddrP2M[2] ,
    \insMemAddrP2M[1] ,
    \insMemAddrP2M[0] }),
    .insMemDataIn({\insMemDataM2P[31] ,
    \insMemDataM2P[30] ,
    \insMemDataM2P[29] ,
    \insMemDataM2P[28] ,
    \insMemDataM2P[27] ,
    \insMemDataM2P[26] ,
    \insMemDataM2P[25] ,
    \insMemDataM2P[24] ,
    \insMemDataM2P[23] ,
    \insMemDataM2P[22] ,
    \insMemDataM2P[21] ,
    \insMemDataM2P[20] ,
    \insMemDataM2P[19] ,
    \insMemDataM2P[18] ,
    \insMemDataM2P[17] ,
    \insMemDataM2P[16] ,
    \insMemDataM2P[15] ,
    \insMemDataM2P[14] ,
    \insMemDataM2P[13] ,
    \insMemDataM2P[12] ,
    \insMemDataM2P[11] ,
    \insMemDataM2P[10] ,
    \insMemDataM2P[9] ,
    \insMemDataM2P[8] ,
    \insMemDataM2P[7] ,
    \insMemDataM2P[6] ,
    \insMemDataM2P[5] ,
    \insMemDataM2P[4] ,
    \insMemDataM2P[3] ,
    \insMemDataM2P[2] ,
    \insMemDataM2P[1] ,
    \insMemDataM2P[0] }),
    .la_data_in({la_data_in[2],
    la_data_in[1]}),
    .wmask({\wmask[3] ,
    \wmask[2] ,
    \wmask[1] ,
    \wmask[0] }));
 sky130_sram_2kbyte_1rw1r_32x512_8 SLRV_IMEM (.csb0(csb),
    .csb1(csb),
    .web0(la_data_in[3]),
    .clk0(wb_clk_i),
    .clk1(wb_clk_i),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .addr0({la_data_in[12],
    la_data_in[11],
    la_data_in[10],
    la_data_in[9],
    la_data_in[8],
    la_data_in[7],
    la_data_in[6],
    la_data_in[5],
    la_data_in[4]}),
    .addr1({\insMemAddrP2M[8] ,
    \insMemAddrP2M[7] ,
    \insMemAddrP2M[6] ,
    \insMemAddrP2M[5] ,
    \insMemAddrP2M[4] ,
    \insMemAddrP2M[3] ,
    \insMemAddrP2M[2] ,
    \insMemAddrP2M[1] ,
    \insMemAddrP2M[0] }),
    .din0({la_data_in[44],
    la_data_in[43],
    la_data_in[42],
    la_data_in[41],
    la_data_in[40],
    la_data_in[39],
    la_data_in[38],
    la_data_in[37],
    la_data_in[36],
    la_data_in[35],
    la_data_in[34],
    la_data_in[33],
    la_data_in[32],
    la_data_in[31],
    la_data_in[30],
    la_data_in[29],
    la_data_in[28],
    la_data_in[27],
    la_data_in[26],
    la_data_in[25],
    la_data_in[24],
    la_data_in[23],
    la_data_in[22],
    la_data_in[21],
    la_data_in[20],
    la_data_in[19],
    la_data_in[18],
    la_data_in[17],
    la_data_in[16],
    la_data_in[15],
    la_data_in[14],
    la_data_in[13]}),
    .dout0({_NC1,
    _NC2,
    _NC3,
    _NC4,
    _NC5,
    _NC6,
    _NC7,
    _NC8,
    _NC9,
    _NC10,
    _NC11,
    _NC12,
    _NC13,
    _NC14,
    _NC15,
    _NC16,
    _NC17,
    _NC18,
    _NC19,
    _NC20,
    _NC21,
    _NC22,
    _NC23,
    _NC24,
    _NC25,
    _NC26,
    _NC27,
    _NC28,
    _NC29,
    _NC30,
    _NC31,
    _NC32}),
    .dout1({\insMemDataM2P[31] ,
    \insMemDataM2P[30] ,
    \insMemDataM2P[29] ,
    \insMemDataM2P[28] ,
    \insMemDataM2P[27] ,
    \insMemDataM2P[26] ,
    \insMemDataM2P[25] ,
    \insMemDataM2P[24] ,
    \insMemDataM2P[23] ,
    \insMemDataM2P[22] ,
    \insMemDataM2P[21] ,
    \insMemDataM2P[20] ,
    \insMemDataM2P[19] ,
    \insMemDataM2P[18] ,
    \insMemDataM2P[17] ,
    \insMemDataM2P[16] ,
    \insMemDataM2P[15] ,
    \insMemDataM2P[14] ,
    \insMemDataM2P[13] ,
    \insMemDataM2P[12] ,
    \insMemDataM2P[11] ,
    \insMemDataM2P[10] ,
    \insMemDataM2P[9] ,
    \insMemDataM2P[8] ,
    \insMemDataM2P[7] ,
    \insMemDataM2P[6] ,
    \insMemDataM2P[5] ,
    \insMemDataM2P[4] ,
    \insMemDataM2P[3] ,
    \insMemDataM2P[2] ,
    \insMemDataM2P[1] ,
    \insMemDataM2P[0] }),
    .wmask0({\wmask[3] ,
    \wmask[2] ,
    \wmask[1] ,
    \wmask[0] }));
endmodule
