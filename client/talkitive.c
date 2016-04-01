#include "talkitive.h"

int talkitive_search(usbmuxd_device_info_t **list)
{
	int res = usbmuxd_get_device_list(list);
	if(res < 0)
	{
		printf("Veuillez lancer le service usbmuxd\n");
		exit(1);
	}
	printf("Appareils trouvé: %d\n", res);
	return res;
}

int talkitive_get_device(usbmuxd_device_info_t *device)
{
	int res = usbmuxd_get_device_by_udid(device->udid, device);
	if(res < 0)
	{
		printf("Veuillez lancer le service usbmuxd\n");
		exit(1);
	}
	printf("Reception des informations..OK\n");
	return res;
}

int talkitive_connect(usbmuxd_device_info_t *device, const unsigned short port)
{
	int res = usbmuxd_connect(device->handle, port);
	if(res < 0)
	{
		printf("Impossible d'ouvrir la connexion. Veuillez lancer le service usbmuxd ou choisir un autre port.\n");
		exit(1);
	}
	printf("Ouverture de la connexion...OK\n");
	return res;
}

int talkitive_disconnect(int buffer)
{
	usbmuxd_disconnect(buffer);
}



int talkitive_send(int socket, char text[])
{


	char data[80];
	strcpy(data, text);


	printf("Envoi de '%s'\n", data);

	int sent_bytes;

	int res = usbmuxd_send(socket, data, strlen(data), &sent_bytes);
	if(res != 0)
	{
		printf("Echec de l'envoi.\nErreur: %d\n", res);
		return 1;
	}
	printf("Message envoyé. Longueur: %d\n", sent_bytes);
	sleep(1); //on attends pour éviter de surcharger le buffer
	return 0;
}

int talkitive_clear(int *socket)
{
	char msg[80];
	sprintf(msg, "clear");
	talkitive_send(*socket, msg);
}

int talkitive_wait(int *socket)
{
	char msg[80];
	sprintf(msg, "wait");
	talkitive_send(*socket, msg);
}

int talkitive_onesend(char msg[])
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
	talkitive_send(buffer, msg);
	talkitive_disconnect(buffer);
}
