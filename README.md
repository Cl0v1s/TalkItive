# TalkItive 

## Description

TalkItive est un projet visant à permettre d'user d'un appareil mobile Apple (Ipod touch, IPhone)
comme un support graphique externe pour Linux permettant d'afficher du texte.

Coté Linux, TalkItive propose une bibliothèques de fonctions C permettant de se connecter à un Idevice et d'envoyer de texte de manière connectée (en gardant la main) ou déconnectée.
Coté Idevice, le projet prend la forme d'une application IOS dévelopée à l'aide de Theos et du SDK Iphone 5.0.

L'application est testée sur un Ipod touch 2G tournant sous [WhiteD00r](http://www.whited00r.com/index?lang=en)(soit dans les faits sous IOS 3.0)

Un programme de test, nommé main dans le répertoire "test" permet d'illustrer les propos expliqués ici. 

##TODO:

* Proposer un support pour [ncurses](http://www.cyberciti.biz/faq/linux-install-ncurses-library-headers-on-debian-ubuntu-centos-fedora/)

## Dépendances

La bibliothèque Linux nécessite : 

* [libusbmux-dev](https://packages.debian.org/jessie/libusbmuxd-dev)
* [usbmuxd](https://packages.debian.org/sid/utils/usbmuxd)

La compilation de l'application IOS demande:

* [Theos](http://iphonedevwiki.net/index.php/Theos/Setup) 
* IphoneSDK5.0 minimum

## Documentation

### Application

Pour compiler et installer l'application, branchez votre Idevice et exécutez le script build.sh situé dans le répertoire app (nécessite lftp et ssh, ainsi que d'entrer le mot de passe root de IOS; "alpine" par défaut).
Cela aura pour effet de placer un éxeutable dans votre Idevice à l'emplacement /private/var/mobile. Vous serez alors en mesure d'executer l'application à l'aide d'un émulateur de terminal. 
L'application se mettra alors en attente de messages provenant de machine Linux.

### Bibliothèque

#### Lexique 

* Mode connecté: L'application se connecte à l'Idevice et garde la main, empéchant d'autres application d'user de la connexion.
* Mode non-connecté: Le logiciel se connecte briévement à l'Idevice, envoie le message demandé et se déconnecte. Permettant à d'autres logiciels d'entrer en contact avec l'Idevice.
* Mode attente: En mode connecté, TalkItive attends 10 passages de boucles avant de rompre la connexion s'il n'a pas de nouvelle de votre machine Linux. Il est possible de lui demander d'attendre indéfiniement jusqu'au prochain message en passant en mode attente (procédure expliquée ci-dessous). A noter que la connexion ne sera jamais rompue par TalkItive coté Idevice defait, si vous passez en mode attente, assurez-vous de toujours pouvoir en sortir, en cas de crash de votre logiciel notamment.


**Note:**Les fonctions ci-dessous sont décrites dans l'ordre dans lequel elles doivent être appelées pour le mode connecté.

#### Recherche d'un appareil

    int talkitive_search(usbmuxd_device_info_t **list);

Afin d'être en mesure d'envoyer des messages en mode connecté, vous devez rechercher un appareil connecté. Cette fonction aura pour effet de retourner, dans la variable list, l'ensemble des Idevice connectés à la machine Linux.

Retourne -1 en cas d'erreur.

#### Obtention des informations sur un appareil 

    int talkitive_get_device(usbmuxd_device_info_t *device);

En vue de se connecter à un appareil, il est nécessaire d'obtenir toutes les informations le concernant. Pour cela, appelez cette méthode en lui passant en paramètre un élement de list, obtenu en appelant talkitive_search (voir ci-dessus).

Retourne -1 en cas d'erreur.

#### Connexion à l'appareil 

    int talkitive_connect(usbmuxd_device_info_t *device, const unsigned short port);

Permet d'obtenir un descripteur de fichier "socket" visant à rendre possile la communication avec l'Idevice "device" passé en paramètre (dont les informations ont été obtenues à l'aide de talkitive_get_device), sur le port "port". A noter que coté Idevice, TalkItive attends, de base des communications sur le port 1234.

Retourne -1 en cas d'erreur. 
Retourne le descripteur de fichier "socket" en cas de réussite.

#### Communication avec l'appareil

    int talkitive_send(int socket, char text[])

Permet d'envoyer le message "text" (c string, soit un tableau de char), sur le descripteur de fichier "socket". La taille maximale d'un message est de 80 caractères.

A noter qu'il existes des commandes spéciales: 

* "clear": envoyer "clear" dans "text" permet de demander à TalkItive d'effacer son écran.
Il est possible d'appeler  directement:
    int talkitive_clear(int *socket)


* "wait": envoyer "wait" dans "text" permet de demander à TalkItive de passer en mode attente (voir lexique). 
Il est possible d'appeler  directement:
    int talkitive_wait(int *socket)

Retourne -1 en cas d'erreur.

#### Rupture de la connexion avec l'Idevice

    int talkitive_disconnect(int socket);

**Note:**Ci-dessous, comment communiquer en mode non-connecté

#### Communiquer en mode non-connecté

    int talkitive_onesend(char msg[]);

Envoi le message "msg" au premier Idevice connecté (Il est bon d'en user que d'un seul dans ce cas) et rompt immédiatement la connexion. 

Retourne -1 en cas d'erreur.
