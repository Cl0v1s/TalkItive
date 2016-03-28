
#include <stdio.h>

#include "/usr/local/include/usbmuxd.h"


//#include "talkitive.h"


int main()
{
	usbmuxd_device_info_t *list_devices;

	int res = usbmuxd_get_device_list(&list_devices);
	if(res < 0)
	{
		printf("Veuillez lancer le service usbmuxd\n");
		return 1;
	}
	printf("Appareils trouvé: %d\n", res);
	if(res == 0)
	{
		printf("Aucun appareil trouvé, arrêt.\n");
		return 1;
	}

	/*idevice_connection_t socket;
	idevice_error_t status = talkitive_connect(&socket);	
	if(status != 0)
		return 0;
	talkitive_send_pixel(socket, 0,0,0);
	return 0;*/
}