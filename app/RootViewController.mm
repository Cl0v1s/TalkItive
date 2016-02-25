#import "RootViewController.h"

@implementation RootViewController
- (void)loadView {
	self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
	self.view.backgroundColor = [UIColor blackColor];
	[self listen_socket];
}

- (void)listen_socket{
	//cette section est en c
	int sock;
	int connection;
	int len;
	struct sockaddr_in server;
	struct sockaddr_in client;

	//création de la structure décrivant le serveur
	sock = socket(AF_INET, SOCK_STREAM, 0);
	server.sin_family = AF_INET;
	server.sin_addr.s_addr = INADDR_ANY;
	server.sin_port = htons(1234);

	//bind
	bind(sock, (struct sockaddr*)&server, sizeof(server));

	//listen
	listen(sock, 3);

	//signifie qu'on attends les connexions
	self.view.backgroundColor = [UIColor whiteColor];
	len = sizeof(struct sockaddr_in);
	connection = accept(sock, (struct sockaddr*)&client, (socklen_t*)&len);

	if(connection < 0)
		self.view.backgroundColor = [UIColor redColor];
	else 
		self.view.backgroundColor = [UIColor greenColor];




}
@end
