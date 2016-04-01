make &&  lftp sftp://root:alpine@127.0.0.1 -e "cd /private/var/mobile;rm Talkative;put obj/Talkative.app/Talkative;bye" && ssh root@127.0.0.1 'cd /private/var/mobile && chmod 777 Talkative'


