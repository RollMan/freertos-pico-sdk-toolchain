#ifndef CUSTOM_TASK_TEST_H
#define CUSTOM_TASK_TEST_H

#include <ConfigurableFirmata.h>
#include <FirmataFeature.h>

class FirmataCustomCommandTest: public FirmataFeature
{
    public:
        FirmataCustomCommandTest();
        void reportDigital(byte port, int value);
        boid report(bool elapsed);
        boid handleCapability(byte pin);
        boolean handleSysex(byte command, byte argc, byte* argv);
        boolean(handlePinMode(byte pin, int mode);
        void reset();
}

#endif
