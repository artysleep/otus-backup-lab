# otus-backup-lab

## Листинг с сервера:
Создадим группу и пользователя, при помощи аттрибутов зададим права rx для целевой директори:
```sh
groupadd -r custom_gr
useradd -r -g custom_gr custom_u -s /bin/bash
passwd custom_u
setfacl -R -m g:custom_gr:rx /docker
```

Проверим размер и аттрибуты 
```sh
[custom_u@redos734 ~]$ getfacl /docker/
getfacl: Removing leading '/' from absolute path names
# file: docker/
# owner: root
# group: root
user::rwx
group::r-x
group:custom_gr:r-x
mask::r-x
other::r-x
```
```sh
[custom_u@redos734 ~]$ du -h /docker --max-depth=1
32K     /docker/db
31M     /docker/app
31M     /docker
```
Поменяем дефолтный контекст
```sh
chcon -R -u staff_u /docker
```
```sh
[custom_u@redos734 ~]$ ls -lahZ /docker
итого 44K
drwxr-xr-x+  4 root root staff_u:object_r:default_t:s0 4,0K янв 30 00:26 .
dr-xr-xr-x. 19 root root system_u:object_r:root_t:s0   4,0K янв 30 00:26 ..
drwxr-xr-x+  3 root root staff_u:object_r:default_t:s0 4,0K янв 30 00:26 app
drwxr-xr-x+  2 root root staff_u:object_r:default_t:s0 4,0K янв 30 00:26 db
-rw-r-xr--+  1 root root staff_u:object_r:default_t:s0 1,3K янв 30 00:26 docker-compose.yml
-rw-r-xr--+  1 root root staff_u:object_r:default_t:s0  111 янв 30 00:26 .env
[custom_u@redos734 ~]$
```
Под пользователем custom_u создадим скрипт backup.sh и укажем исполнение каждое воскресенье
  [backup.sh] [crontab -l]

  [backup]: <[https://github.com/](https://github.com/artysleep/otus-backup-lab/blob/main/backup.sh)https://github.com/artysleep/otus-backup-lab/blob/main/backup.sh>
