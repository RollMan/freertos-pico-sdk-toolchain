#include <Arduino.h>

void setup(void){
    Serial.begin(9600);
    Serial.println("Hi");
}

int count=0;
void loop(){
        Serial.print("count ");
        Serial.print(count);
        Serial.print("\r\n");
        count++;
}
