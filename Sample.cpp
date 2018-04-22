#include <iostream>
#include <string.h>
#include <stdbool.h>
#include <tchar.h>
#include <windows.h>

#include "..\include\Leap.h"
#include "..\include\LeapC.h"
#include "usb.h"

using namespace Leap;

/////// GLOBAL PORT VARIABLEUSED FOR SENDING FRAME DATA ///////////

SerialPort port;

////////////////////////////////////////////////////////////////////

class SampleListener : public Listener {
public:
	virtual void onConnect(const Controller&);
	virtual void onFrame(const Controller&);
};

void SampleListener::onConnect(const Controller& controller) {
	std::cout << "Connected" << '\n';
}

void SampleListener::onFrame(const Controller& controller) {
	const Frame frame = controller.frame();
	float buffer[3];
	
	std::cout << "Frame Rate: " << frame.currentFramesPerSecond() << '\n';
	if (!frame.hands().isEmpty()) {
		buffer[0] = frame.hands()[0].wristPosition()[0];
		buffer[1] = frame.hands()[0].wristPosition()[1];
		buffer[2] = frame.hands()[0].wristPosition()[2];
		std::cout << "Hands: " << frame.hands()[0].wristPosition() << '\n';
		port.sendFloat(buffer, 3);
	}
		
}

int main(int argc, char **argv) {
	SampleListener listener;
	Controller ctrl;
	SerialPort port1;

	port.connect(TEXT("COM4"));
	ctrl.addListener(listener);
	std::cin.get();
	ctrl.removeListener(listener);

	port.disconnect();
	return 0;
}
