#include <windows.devices.serialcommunication.h>
#include <usbdi.h>
#include <tchar.h>
#include "usb.h"
#include "float_to_fixed.h"

SerialPort::SerialPort() {
	serialPortHandle = INVALID_HANDLE_VALUE;
}

SerialPort::~SerialPort() {
	if (serialPortHandle != INVALID_HANDLE_VALUE)
		CloseHandle(serialPortHandle);

	serialPortHandle = INVALID_HANDLE_VALUE;
}

int SerialPort::connect() {
	return connect(TEXT("COM11"));
}

int SerialPort::connect(TCHAR* device) {
	int error = 0;
	DCB dcb;

	memset(&dcb, 0, sizeof(dcb));

	dcb.DCBlength = sizeof(dcb);

	dcb.BaudRate = 115200;
	dcb.Parity = NOPARITY;
	dcb.fParity = 0;
	dcb.StopBits = ONESTOPBIT;
	dcb.ByteSize = 8;

	serialPortHandle = CreateFile(device, GENERIC_READ | GENERIC_WRITE, 0, NULL, OPEN_EXISTING, NULL, NULL);

	if (serialPortHandle != INVALID_HANDLE_VALUE) {
		if (!SetCommState(serialPortHandle, &dcb))
			error = 2;
	}
	else {
		error = 1;
	}

	if (error != 0) {
		disconnect();
	}
	else {
		printf("Connected to COM11\n");
		clear();
	}

	if (error != 0) printf("ERROR: Could not connect (%d)\n", error);
	return error;
}

void SerialPort::disconnect(void) {
	CloseHandle(serialPortHandle);
	serialPortHandle = INVALID_HANDLE_VALUE;
}

int SerialPort::sendArray(unsigned char *buffer, int len) {
	unsigned long result;

	if (serialPortHandle != INVALID_HANDLE_VALUE) {
		WriteFile(serialPortHandle, buffer, len, &result, NULL);
		if (result != 0) {
			printf("Buffer Written: ");
			for (int i = 0; i < len; i++)
				printf("%x ",buffer[i]);
		}
		printf("\n");
			
	}
	return result;
}

int SerialPort::sendFloat(float *buffer, int len) {
	unsigned long result;

	if (serialPortHandle != INVALID_HANDLE_VALUE) {
		WriteFile(serialPortHandle, buffer, len, &result, NULL);
		if (result != 0) {
			printf("Buffer Written: ");
			for (int i = 0; i < len; i++)
				printf("%f ", buffer[i]);
		}
		printf("\n");
	}
	return result;
}

int SerialPort::sendFixed(fixed_point<int,16> *buffer, int len) {
	unsigned long result;

	if (serialPortHandle != INVALID_HANDLE_VALUE) {
		WriteFile(serialPortHandle, buffer, len, &result, NULL);
		if (result != 0) {
			printf("Buffer Written: ");
			for (int i = 0; i < len; i++)
				printf("%x ", buffer[i]);
		}
		printf("\n");
	}
	return result;
}

int SerialPort::getArray(unsigned char *buffer, int len) {
	unsigned long read_nbr;

	read_nbr = 0;
	if (serialPortHandle != INVALID_HANDLE_VALUE)
	{
		ReadFile(serialPortHandle, buffer, len, &read_nbr, NULL);
	}

	return((int)read_nbr);
}

void SerialPort::clear() {
	PurgeComm(serialPortHandle, PURGE_RXCLEAR | PURGE_TXCLEAR);
}
