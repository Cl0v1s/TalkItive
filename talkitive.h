#ifndef TALKITIVE_H
#define TALKITIVE_H

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include <libimobiledevice/libimobiledevice.h>

idevice_error_t talkitive_connect(idevice_connection_t *socket);

idevice_error_t talkitive_send_pixel(idevice_connection_t socket, uint x, uint y, uint color);

#endif