
#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xbasic_types.h"
#include "xparameters.h"
#include "xil_io.h"
#include "sleep.h"


Xuint32 *baseaddr = (Xuint32 *)0x43C00000;

int main()
{
    init_platform();

    int slv_reg0, slv_reg1, slv_reg2, slv_reg3;
    int slv_reg4, slv_reg5, slv_reg6, slv_reg7;
    int slv_reg12;
    int ctext_0, ctext_1, ctext_2, ctext_3;





    slv_reg0 = 0; slv_reg1 = 0; slv_reg2 = 0; slv_reg3 = 0; 
slv_reg4 = 0; slv_reg5 = 0; slv_reg6 = 0; slv_reg7 = 0; 
slv_reg12 = 0;


    slv_reg12 = 1; 

    Xil_Out32((baseaddr + 12), slv_reg12); 
    slv_reg12 = 0;
    Xil_Out32((baseaddr + 12), slv_reg12); 



    Xil_Out32((baseaddr + 4), slv_reg4);
    Xil_Out32((baseaddr + 5), slv_reg5);
    Xil_Out32((baseaddr + 6), slv_reg6);
    Xil_Out32((baseaddr + 7), slv_reg7);


    Xil_Out32((baseaddr + 0), slv_reg0);
    Xil_Out32((baseaddr + 1), slv_reg1);
    Xil_Out32((baseaddr + 2), slv_reg2);
    Xil_Out32((baseaddr + 3), slv_reg3);





    ctext_0 = Xil_In32((baseaddr + 8));  // LSB
    ctext_1 = Xil_In32((baseaddr + 9));
    ctext_2 = Xil_In32((baseaddr + 10));
    ctext_3 = Xil_In32((baseaddr + 11)); // MSB


    xil_printf("cipher[127:96] = %08x\n\r", ctext_3);
    xil_printf("cipher[95:64] = %08x\n\r", ctext_2);
    xil_printf("cipher[63:32] = %08x\n\r", ctext_1);
    xil_printf("cipher[31:0]  = %08x\n\r", ctext_0);



    cleanup_platform();
    return 0;
}

