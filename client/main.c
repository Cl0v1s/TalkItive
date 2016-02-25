
#include <libimobiledevice/libimobiledevice.h>

#include "talkitive.h"


int main()
{
	idevice_connection_t socket;
	idevice_error_t status = talkitive_connect(&socket);	
	if(status != 0)
		return 0;
	talkitive_send_pixel(socket, 0,0,0);
	return 0;
}