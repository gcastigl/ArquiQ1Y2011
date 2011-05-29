#include "../include/interrupts.h"

void setTestConditions(int count) {
	*counter = count;
	*cpuTest = TRUE;
}

int getCounter() {
	return *counter;
}

//Timer Tick
void int_08() {
	printf("int: %d\n", *counter);
	if (*cpuTest == TRUE) {
		*counter--;
		if (*counter == 0) {
			*cpuTest = FALSE;
		}
	}
}

//Keyboard
void int_09() {
	char c = handleScanCode(inb(0x60));
	if (c != -1) {
		append(c);
	}
	if (IS_CTRL() && IS_ALT() && IS_DEL()) {
		_reset();
	}
	return;
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

