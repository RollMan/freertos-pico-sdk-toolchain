#include <stdio.h>
#include <pico/stdlib.h>
int main(void){
    stdio_init_all();
    printf("Hello\n");

    int count=0;
    while(true){
        printf("count %d\n", count);
        count++;
    }
    return 0;
}
