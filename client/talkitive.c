#include "talkitive.h"

idevice_error_t talkitive_connect(idevice_connection_t *socket)
{
	int i = 0;
	char **list;
	int count;
	printf("Récupération des périphériques...\n");
	idevice_error_t status = idevice_get_device_list(&list, &count);
	if(status != 0)
	{
		printf("Impossible de récupérer les périphériques.\nErreur %i\n", status);
		return status;
	}
	printf("Appareils détéctés: %i\n", count);
	for(i= 0; i!= count; i++)
	{
		printf("UID %i: %s\n",i, list[i]);
	}
	printf("Connexion au device 0...\n");
	idevice_t device;
	status = idevice_new(&device, list[i]);
	if(status != 0)
	{
		printf("Impossible de se connecter au device phase 1...\n");
		return status;
	}
	status = idevice_connect(device, 22, socket); //seul le port 22 semble fonctionner pour une raison que j'ignore 
	if(status != 0)
	{
		printf("Impossible de se connecter au device phase 2\nErreur: %i\n", status);
		return status;
	}
	printf("Connexion établie\n");
	return 0;
}

idevice_error_t talkitive_send_pixel(idevice_connection_t socket, uint x, uint y, uint color)
{

	char x_data[15];
	char y_data[15];
	char color_data[15];	
	sprintf(x_data,"%d", x);
	sprintf(y_data,"%d", y);
	sprintf(color_data,"%d", color);


	char data[80];
	strcpy(data, "pixel ");
	strcat(data, x_data);
	strcat(data, " ");
	strcat(data, y_data);
	strcat(data, " ");
	strcat(data, color_data);

	printf("Envoi de '%s'\n", data);

	int sent_bytes;

	idevice_error_t status = idevice_connection_send(socket, data, strlen(data), &sent_bytes);
	if(status != 0)
	{
		printf("Echec de l'envoi.\nErreur: %d\n", status);
		return status;
	}
	printf("Message envoyé. Longueur: %d\n", sent_bytes);
	return 0;
}
