#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h> 
#include <sys/socket.h>
#include <netinet/in.h>
#include <syslog.h>

@interface RootViewController: UIViewController {
}

@property char* array;
@property int width;
@property int height;
@property FILE *logs;

- (void)listen_socket;
- (void)draw_array;


@end
