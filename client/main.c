
#include <stdio.h>
#include <string.h>
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




	/*idevice_connection_t socket;
	idevice_error_t status = talkitive_connect(&socket);	
	if(status != 0)
		return 0;
	talkitive_send_pixel(socket, 0,0,0);
	return 0;*/
}