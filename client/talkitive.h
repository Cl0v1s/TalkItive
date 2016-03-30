#ifndef TALKITIVE_H
#define TALKITIVE_H

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "/usr/local/include/usbmuxd.h"

int talkitive_search(usbmuxd_device_info_t **list);
int talkitive_get_device(usbmuxd_device_info_t *device);
int talkitive_connect(usbmuxd_device_info_t *device, const unsigned short port);
int talkitive_disconnect(int buffer);
int talkitive_send(int socket, char txt[]);
#endif