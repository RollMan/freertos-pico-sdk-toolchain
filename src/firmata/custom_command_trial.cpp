#include <ConfigurableFirmata.h>
#include "custom_command_trial.h"

FirmataCustomCommandTestToServer::FirmataCustomCommandTestToServer()
{
}

boolean FirmataCustomCommandTestToServer::handleSysex(byte command, byte argc, byte* argv)
{
    if (command == CUSTOM_COMMAND_TOCLIENT){
        // turn on led 2
        pinMode(2, OUTPUT);
        digitalWrite(2, HIGH);
        return true;
    }
    return false;
}


void FirmataCustomCommandTestToServer::reportDigital(byte port, int value){}
void FirmataCustomCommandTestToServer::report(bool elapsed){}
void FirmataCustomCommandTestToServer::handleCapability(byte pin){}
boolean FirmataCustomCommandTestToServer::handlePinMode(byte pin, int mode){ return false; }
void FirmataCustomCommandTestToServer::reset(){}
