#include "../include/interrupts.h"

unsigned int count = 0;

unsigned int getIrq0Count() {
	return count;
}

//Timer Tick
void int_08() {
	count++;
}

//Keyboard
void int_09() {
	if (handleScanCode(inb(0x60))) {
		//keyPressed();
	}
	if (IS_CTRL() && IS_ALT() && IS_DEL()) {
		_reset();
	}
}

void int_80(int sysCallNumber, void ** args) {
	switch(sysCallNumber) {
		case SYSTEM_WRITE:
			sysWrite((int) args[0], args[1], (int)args[2]);
			break;
		case SYSTEM_READ:
			sysRead((int) args[0], args[1],(int)args[2]);
			break;
	}
}

