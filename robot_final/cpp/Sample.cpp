#pragma once
#include <iostream>
#include <string.h>
#include <stdbool.h>
#include <tchar.h>
#include <windows.h>
#include <ctime>
#include <math.h>
#include <cmath>

#include "..\include\Leap.h"
#include "..\include\LeapC.h"
#include "usb.h"
#include "float_to_fixed.h"

using namespace Leap;

/////// GLOBAL PORT VARIABLEUSED FOR SENDING FRAME DATA ///////////

SerialPort port;
const float ARM_LENGTH = 500.0/16.0;

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
	const unsigned int b_size = 4;
	const Frame frame = controller.frame();
	fixed_point<int, 16> buffer[b_size];
	float base_angle = 0.0;
	float hand_x, hand_z, x_send, y_send, r;
	Leap::FingerList fingers;
	Leap::Vector indexTipPos;
	
	if (!frame.hands().isEmpty()) {
		Leap::FingerList indexFingerList = frame.hands()[0].fingers().fingerType(Leap::Finger::TYPE_INDEX);
		Leap::Finger indexFinger = indexFingerList[0]; //since there is only one per hand
		indexTipPos = indexFinger.tipPosition();
		hand_x = indexTipPos[0];
		hand_z = -1.0*indexTipPos[2];
		base_angle = atan(hand_z / hand_x);
		if (base_angle < 0) base_angle += PI;

		x_send = hand_z / sin(base_angle);     // flattened x
		// for the scaling issues
		x_send /= 16.0;
		y_send = indexTipPos[1] / 16.0;
		r = sqrt(x_send * x_send + y_send * y_send);
		if (r > ARM_LENGTH) {
			x_send *= (ARM_LENGTH / r);
			y_send *= (ARM_LENGTH / r);
		}


		std::cout << base_angle << '\n';
		buffer[3] = x_send;
		buffer[2] = y_send;
		buffer[1] = base_angle;
		buffer[0] = (frame.hands()[0].pinchStrength()*PI - (PI/2));
		std::cout << x_send << ' ' << indexTipPos[1] <<  '\n';
		std::cout << "magnitude: " << r << '\n';
		std::cout << "x_send: " << x_send << '\n';
		std::cout << "y_send: " << y_send << '\n';
		std::cout << "Pinch Strength: " << frame.hands()[0].pinchStrength() << '\n';

		port.sendArray(reinterpret_cast<unsigned char*>(buffer), 16);
	}
		
}

int main(int argc, char **argv) {
	SampleListener listener;
	Controller ctrl;
	SerialPort port1;

	port.connect(TEXT("\\\\.\\COM11"));
	ctrl.addListener(listener);
	std::cin.get();
	ctrl.removeListener(listener);

	return 0;
}
