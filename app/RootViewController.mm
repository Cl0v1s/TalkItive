#import "RootViewController.h"

@implementation RootViewController
- (void)loadView {
	self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
	self.view.backgroundColor = [UIColor greenColor];

	//intialisation des propriétés
	self.width = 320;
	self.height = 480;
	self.array = (char*)malloc(self.width*self.height*sizeof(char));
	int i,u;
	for(i = 0; i != self.width; i++)
	{
		for(u = 0; u != self.height; u++)
		{
			self.array[i*self.height+u] = 255;
		}
	}
	self.view.backgroundColor = [UIColor purpleColor];

	self.view.backgroundColor = [UIColor blueColor];
	[self listen_socket];
}

- (void)draw_array
{
	CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext=CGBitmapContextCreate(self.array, self.width, self.height, 8, self.height*self.width, colorSpace,  kCGImageAlphaPremultipliedLast | kCGBitmapByteOrderDefault);
    CFRelease(colorSpace);

    CGImageRef cgImage=CGBitmapContextCreateImage(bitmapContext);
    CGContextRelease(bitmapContext);

    UIImage * newimage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    UIImageView * imageView = [[UIImageView alloc] initWithImage:newimage];
	self.view.backgroundColor = [UIColor whiteColor];

	[self.view addSubview:imageView ];
	[self.view sendSubviewToBack:imageView ];
	[self.view setNeedsDisplay];
	[imageView release]; 
}

- (void)listen_socket{
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
		if(strstr(data, "pixel") != 0)
		{

			int x, y, color; 
	//self.view.backgroundColor = [UIColor purpleColor];

			sscanf(data, "pixel %d %d %d", &x, &y, &color);

			self.array[x*self.width+y] = color;
			[self draw_array];
		}




}
@end
