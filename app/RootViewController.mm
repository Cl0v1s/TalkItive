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
	self->entries = [[NSMutableArray alloc] init];


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
	self.view.backgroundColor = [UIColor blueColor];

	char data[80];
	struct timeval otp,ntp;
	while(1==1)
	{
		NSLog(@"Waitin");
		gettimeofday(&otp,NULL);
		if(recv(connection, &data, 13, MSG_WAITALL) > 0)
		{

			//analyse du contenu de la commande
			NSString *marketPacket = [NSString stringWithCString:data encoding:NSASCIIStringEncoding];
			NSLog(@"Recu: %@", marketPacket);

			[self->entries insertObject : marketPacket atIndex: 0];
			[self showEntries];
		}
		memset(data, 0, sizeof data);
		gettimeofday(&ntp,NULL);
		if(abs(ntp.tv_sec-otp.tv_sec) <1 )
			return;
		NSLog(@" End Waitin");

	}
}

- (void)waiting: (int*) cnx
{


}

- (void)showEntries 
{
	//Nettoyage de l'interface
	[[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
	//Ajout
	//CGFloat screenWidth= [[UIScreen mainScreen] bounds].size.width;
	CGFloat screenHeight = self.view.frame.size.height;
	NSLog(@"Affiche: %.3f", screenHeight);

	int i = 1;
	NSString * entry;
	for (entry in self->entries)
	{
		NSLog(@"Affiche: %@", entry);
		UILabel  * label = [[UILabel alloc] initWithFrame:CGRectMake(0, screenHeight-40-20*i, 300, 50)];
	    label.backgroundColor = [UIColor clearColor];
	    label.textAlignment = UITextAlignmentLeft; // UITextAlignmentCenter, UITextAlignmentLeft
	    label.textColor=[UIColor whiteColor];
	    label.text = entry;
	    [self.view addSubview:label];
		i++;
	}
	[self.view setNeedsDisplay];
}

@end
