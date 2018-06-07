#include <stdio.h>
#include <windows.devices.serialcommunication.h>
#include "float_to_fixed.h"

class SerialPort {
private:
	HANDLE serialPortHandle;

public:
	SerialPort();
	~SerialPort();

	int connect();
	int connect(TCHAR* device);
	//int connect (char *deviceName, int baudRate, SerialParity parity);
	void disconnect(void);

	int sendArray(unsigned char *buffer, int len);
	int sendFloat(float *buffer, int len);
	int sendFixed(fixed_point<int, 16> *buffer, int len);
	int getArray(unsigned char *buffer, int len);

	void clear();
};
