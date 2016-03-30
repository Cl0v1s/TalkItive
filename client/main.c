
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "talkitive.h"


int main()
{
	usbmuxd_device_info_t *list_devices;
	usbmuxd_device_info_t device;

	int count = talkitive_search(&list_devices);
	if(count <= 0)
		return;
	//copie d'un des uid dans le device allant étre usité pour la suite
	memcpy(&device.udid, &list_devices[0].udid, sizeof device.udid);
	talkitive_get_device(&device);

	int buffer = talkitive_connect(&device, 1234);
	int i = 0;
	while(1==1)
	{
		char msg[80];
		sprintf(msg, "msg #%d", i);
		talkitive_send(buffer, msg);
		sleep(2);
		i++;
	}

	talkitive_disconnect(buffer);
	return 0;
}