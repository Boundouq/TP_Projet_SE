/*======================================================================*/
/* TIMA LABORATORY                                                      */
/*======================================================================*/
// #include "encoding.h"
// #include "util.h"
// #include <stdio.h>

char text[] = "Vafgehpgvba frgf jnag gb or serr!";

void foo()
{
    int i = 0;
    while (text[i]) {
        char lower = text[i] | 32;
        if (lower >= 'a' && lower <= 'm')
            text[i] += 13;
        else if (lower > 'm' && lower <= 'z')
            text[i] -= 13;
        i++;
    }
}

#define SIZE 20
//volatile int wait = 1;
int main(int argc, char** argv)
{
    int i;
    extern int _tab_X[], _tab_Y[], _tab_Z[];
    extern char _str_welcome [];
    char str[30];
    strcpy( str , _str_welcome);
    //while(wait)
    //  ;
    for ( i = 0 ; i < SIZE ; i++){
      _tab_Z[i] = _tab_X[i] * _tab_Y[i];
      printf(" X_%d value : %d & Y_%d value : %d \n",i , _tab_X[i],i ,_tab_Y[i]);
      printf(" ==> Z_%d value : %d \n",i,_tab_Z[i] );
    }
    printf ("The string _str_welcome is : %s \n" , str);
    printf("Old text: %s \n", text);
    foo();
    printf("New text: %s \n", text);
    //while(!wait)
    //  ;
    return 0;
}
