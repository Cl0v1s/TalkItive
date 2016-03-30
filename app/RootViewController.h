#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h> 
#include <sys/socket.h>
#include <netinet/in.h>
#include <syslog.h>
#include <pthread.h>
#include <sys/time.h>
#include <math.h>


@interface RootViewController: UIViewController {
	NSMutableArray *entries;
}


- (void)listen_socket;
- (void)waiting: (int*) cnx;
- (void)showEntries;


@end
