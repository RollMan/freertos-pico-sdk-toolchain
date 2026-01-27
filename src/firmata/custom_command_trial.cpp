#include <ConfigurableFirmata.h>
#include "custom_command_trial.h"

FirmataCustomCommandTestToServer::FirmataCustomCommandTestToServer()
{
}

boolean FirmataCustomCommandTestToServer::handleSysex(byte command, byte argc, byte* argv)
{
    if (command == CUSTOM_COMMAND_TOSERVER){
        // turn on led 2
        pinMode(2, OUTPUT);
        digitalWrite(2, HIGH);
        write_data();
        return true;
    }
    return false;
}

void FirmataCustomCommandTestToServer::write_data(void)
{
    size_t length = 4;
    byte sending[length] = {CUSTOM_COMMAND_TOCLIENT, 0x06, 0x07, 0x3c, 0x5f};
    Firmata.startSysex();
    Firmata.write(sending, length);
    Firmata.endSysex();
}


void FirmataCustomCommandTestToServer::reportDigital(byte port, int value){}
void FirmataCustomCommandTestToServer::report(bool elapsed){}
void FirmataCustomCommandTestToServer::handleCapability(byte pin){}
boolean FirmataCustomCommandTestToServer::handlePinMode(byte pin, int mode){ return false; }
void FirmataCustomCommandTestToServer::reset(){}
