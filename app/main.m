#include <stdio.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>

int wait_for_client(int *sock, int *cnx);

//Recois les messages du client
int receive_from_client(int *sock, int *cnx)
{

	//boucle de reception des commandes
	Boolean stay = NO;
	int waiting = 10;
	char data[80];
	memset(data, 0, 80);

	while(1==1)
	{

		if(recv(*cnx, &data, 80, 0) > 0)
		{
			stay = NO;
			if(strcmp(data, "clear") == 0)
			{
			    system("clear");
			}
			else if (strcmp(data, "wait") == 0)
			{
				stay = YES;
			}
			else
				printf("%s\n", data);
			waiting = 10;

		}
		else if(waiting <= 0)
		{
			//printf("La connexion a ete perdue\n");
			wait_for_client(sock, cnx);
			return 1;
		}
		else if(stay == NO)
			waiting--;
		memset(data, 0, 80);
		usleep(2500);
	}

	return 0;

}


//Attends un client 
int wait_for_client(int *sock, int *cnx)
{

	struct sockaddr_in server;
	struct sockaddr_in client;
	int len;
	if(sock != NULL)
	{
		close(*sock);
		close(*cnx);
	}

	//création de la structure décrivant le serveur
	*sock = socket(AF_INET, SOCK_STREAM, 0);



	server.sin_family = AF_INET;
	server.sin_addr.s_addr = INADDR_ANY;
	server.sin_port = htons(1234);

	//bind
	bind(*sock, (struct sockaddr*)&server, sizeof(server));

	//printf("En attente...\n");

	//listen
	listen(*sock, 3);


	//signifie qu'on attends les connexions
	len = sizeof(struct sockaddr_in);
	(*cnx) = accept(*sock, (struct sockaddr*)&client, (socklen_t*)&len);

	if(*cnx < 0)
	{
		printf("Une erreur est survenue lors de la connexion.\n");
		return 1;
	}
	//system("clear");
	//printf("Connexion acceptee, debut de la transmission...\n\n");
	//printf("-----------------------------------------\n");
	receive_from_client(sock, cnx);
	return 0;
}



int main(int argc, char **argv) {
	NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
	system("clear");
	printf("=========================================\n");
	printf("TalkItive\n");
	printf("=========================================\n");

	//Attente de la connexion
	int sock;
	int connection;

	if(wait_for_client(&sock, &connection) == 1)
		return 1;

	[p drain];
	return 0;
}

