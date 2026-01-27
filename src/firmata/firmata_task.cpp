#include "./firmata_task.h"
#include <ConfigurableFirmata.h>
#include "./custom_command_trial.h"
FirmataCustomCommandTestToServer custom_command_test_toserver;

#include <DigitalOutputFirmata.h>
DigitalOutputFirmata digitalOutput;

#include <FirmataExt.h>
FirmataExt firmataExt;

void systemResetCallback(){
	for (byte i = 0; i < TOTAL_PINS; i++) 
	{
		if (FIRMATA_IS_PIN_ANALOG(i)) 
		{
			Firmata.setPinMode(i, PIN_MODE_ANALOG);
		} 
		else if (IS_PIN_DIGITAL(i)) 
		{
			Firmata.setPinMode  (i, PIN_MODE_OUTPUT);
		}
	}
	firmataExt.reset();
}

void init_firmata(){
    Firmata.setFirmwareNameAndVersion("ConfigurableFirmata", FIRMATA_FIRMWARE_MAJOR_VERSION, FIRMATA_FIRMWARE_MINOR_VERSION);
    // NOTE: may need initialization of a serial port.
    Firmata.begin(115200);  // TODO: variable baud rate
    Firmata.sendString(F("Booting device. Stand by..."));
    firmataExt.addFeature(digitalOutput);
    firmataExt.addFeature(custom_command_test_toserver);
    Firmata.attach(SYSTEM_RESET, systemResetCallback);
    Firmata.parse(SYSTEM_RESET);
    Firmata.sendString(F("Firmata initialized."));
}

void firmata_task(void *params __attribute__((unused))){
    while(Firmata.available()){
        Firmata.processInput();
        if (!Firmata.isParsingMessage()){
            break;
        }
    }
}
