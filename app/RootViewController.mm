#import "RootViewController.h"

void* PosixThreadMainRoutine(void* data)
{

	RootViewController *self = (RootViewController *)data;
    // Do some work here.
	NSLog(@"FROM THREAD");

	[self listen_socket];
    return NULL;
}


@implementation RootViewController
- (void)loadView {
	self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
	self.view.backgroundColor = [UIColor whiteColor];

	//intialisation des propriétés

	//Création du thread
	pthread_attr_t  attr;
    pthread_t       posixThreadID;
    int             returnVal; 
    returnVal = pthread_attr_init(&attr);
    returnVal = pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
    pthread_create(&posixThreadID, &attr, &PosixThreadMainRoutine, self);
}

- (void)listen_socket{
	NSLog(@"FROM SOCKET");

	//cette section du code est en c
	int sock;
	int connection;
	int len;
	struct sockaddr_in server;
	struct sockaddr_in client;

	//création de la structure décrivant le serveur
	sock = socket(AF_INET, SOCK_STREAM, 0);

	self.view.backgroundColor = [UIColor whiteColor];


	server.sin_family = AF_INET;
	server.sin_addr.s_addr = INADDR_ANY;
	server.sin_port = htons(1234);

	//bind
	bind(sock, (struct sockaddr*)&server, sizeof(server));

	self.view.backgroundColor = [UIColor blueColor];


	//listen
	listen(sock, 3);

	self.view.backgroundColor = [UIColor purpleColor];


	//signifie qu'on attends les connexions
	len = sizeof(struct sockaddr_in);
	connection = accept(sock, (struct sockaddr*)&client, (socklen_t*)&len);

	if(connection < 0)
		self.view.backgroundColor = [UIColor redColor];
	else
		self.view.backgroundColor = [UIColor greenColor];

	//boucle de reception des commandes
	char data[80];
	self.view.backgroundColor = [UIColor blueColor];

	recv(connection, &data, 80, MSG_WAITALL);

	//analyse du contenu de la commande
	NSString *marketPacket = [NSString stringWithCString:data encoding:NSASCIIStringEncoding];
	NSLog(@"Recu: %@", marketPacket);




}
@end
