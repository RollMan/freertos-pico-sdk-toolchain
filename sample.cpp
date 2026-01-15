#include <Arduino.h>
#include <ConfigurableFirmata.h>
#include "src/firmata/firmata_task.h"
void setup(void){
    init_firmata();
    pinMode(D2, OUTPUT);
    digitalWrite(D2, HIGH);
}

void loop(){
    // this ne
    firmata_task(NULL);
}
