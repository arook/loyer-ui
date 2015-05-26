#! /bin/sh
grunt build
scp -r dist/index.html root@42.120.13.112:/mnt/www/vdingtong.cn/public/dist/
scp -r dist/scripts/* root@42.120.13.112:/mnt/www/vdingtong.cn/public/dist/scripts
scp -r dist/views/* root@42.120.13.112:/mnt/www/vdingtong.cn/public/dist/views
scp -r dist/styles/* root@42.120.13.112:/mnt/www/vdingtong.cn/public/dist/styles
scp -r dist/fonts/* root@42.120.13.112:/mnt/www/vdingtong.cn/public/dist/fonts


# scp -r dist/index.html root@42.120.13.112:/mnt/www/vdingtong.cn/public/V2/
# scp -r dist/scripts/* root@42.120.13.112:/mnt/www/vdingtong.cn/public/V2/scripts
# scp -r dist/views/* root@42.120.13.112:/mnt/www/vdingtong.cn/public/V2/views
# scp -r dist/styles/* root@42.120.13.112:/mnt/www/vdingtong.cn/public/V2/styles
# scp -r dist/fonts/* root@42.120.13.112:/mnt/www/vdingtong.cn/public/V2/fonts
