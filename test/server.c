#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h> 
#include <sys/socket.h>
#include <netinet/in.h>
#include <string.h>

int main()
{
	int sock;
	int connection;
	int len;
	struct sockaddr_in server;
	struct sockaddr_in client;

	printf("Ouverture du socket...");
	//création de la structure décrivant le serveur
	sock = socket(AF_INET, SOCK_STREAM, 0);
	printf("OK\n");

	server.sin_family = AF_INET;
	server.sin_addr.s_addr = INADDR_ANY;
	server.sin_port = htons(1234);

	//bind
	printf("Binding du port...");
	bind(sock, (struct sockaddr*)&server, sizeof(server));
	printf("OK\n");

	//listen
	printf("Listen...");
	listen(sock, 3);
	printf("OK\n");

	//signifie qu'on attends les connexions
	len = sizeof(struct sockaddr_in);
	printf("En attente de la connexion...");
	connection = accept(sock, (struct sockaddr*)&client, (socklen_t*)&len);
	printf("OK\n");

	char *msg = "Ca marche";
	send(connection,msg, strlen(msg),0);

}
