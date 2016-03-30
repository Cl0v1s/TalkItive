make package && mv com.portron.*.deb talk.deb &&  lftp sftp://root:alpine@127.0.0.1 -e "cd /private/var/mobile/debs;rm talk.deb;put talk.deb;bye" && ssh root@127.0.0.1 'cd /private/var/mobile/debs && dpkg -i talk.deb'


