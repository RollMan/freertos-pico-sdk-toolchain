#include "firmata_task.h"
#include <ConfigurableFirmata.h>

void systemResetCallback(){
    // Do nothing until FirmataExt is used.
}

void init_firmata(){
    Firmata.setFirmwareNameAndVersion("ConfigurableFirmata", FIRMATA_FIRMWARE_MAJOR_VERSION, FIRMATA_FIRMWARE_MINOR_VERSION);
    // NOTE: may need initialization of a serial port.
    Firmata.begin(115200);  // TODO: variable baud rate
    Firmata.sendString(F("Booting device. Stand by..."));
    Firmata.attach(SYSTEM_RESET, systemResetCallback);
    Firmata.parse(SYSTEM_RESET);
}

void firmata_task(void *params __attribute__((unused))){
    while(Firmata.available()){
        Firmata.processInput();
        if (!Firmata.isParsingMessage()){
            break;
        }
    }
}
