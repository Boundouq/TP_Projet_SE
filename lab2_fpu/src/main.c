/*======================================================================*/
/* TIMA LABORATORY                                                      */
/*======================================================================*/
// #include "encoding.h"
// #include "util.h"

int f_rounding_mode = 0;
int fflags = 0;

int main ()
{

    float f=0.001;
    int fi;

    fi = f*1000;
    do{
        printf("fi = %d \n", fi);

        f += 0.001f;
        fi = f*1000;
    }while(fi != 999);

    return 0;


    return 0;
}
