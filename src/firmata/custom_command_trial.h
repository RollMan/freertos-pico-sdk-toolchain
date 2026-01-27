#ifndef CUSTOM_TASK_TEST_H
#define CUSTOM_TASK_TEST_H

#include <ConfigurableFirmata.h>
#include <FirmataFeature.h>

#define CUSTOM_COMMAND_TOCLIENT (0x0E)
#define CUSTOM_COMMAND_TOSERVER (0x0F)

class FirmataCustomCommandTestToServer: public FirmataFeature
{
    public:
        FirmataCustomCommandTestToServer();
        void reportDigital(byte port, int value);
        void report(bool elapsed);
        void handleCapability(byte pin);
        boolean handleSysex(byte command, byte argc, byte* argv);
        boolean handlePinMode(byte pin, int mode);
        void reset();
    private:
        void write_data(void);
};

#endif
