# otus-backup-lab

## Листинг с сервера:
Создадим группу и пользователя, при помощи аттрибутов зададим права rx для целевой директории:
```sh
groupadd -r custom_gr
useradd -r -g custom_gr custom_u -s /bin/bash
passwd custom_u
setfacl -R -m g:custom_gr:rx /docker
```

Проверим размер и аттрибуты:
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
Поменяем дефолтный контекст:
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
Под пользователем custom_u создадим скрипт [backup.sh] и укажем исполнение каждое воскресение в [crontab]:

[backup.sh]: <https://github.com/artysleep/otus-backup-lab/blob/main/backup.sh>
[crontab]: <https://github.com/artysleep/otus-backup-lab/blob/main/crontab%20-l>

Для теста задача отрабатывает каждую минуту c записью отдельного [лога]:
```sh
[custom_u@redos734 ~]$ ls -lah /var/log/bkp
итого 2,7M
drwx------.  2 custom_u custom_gr 4,0K янв 30 02:22 .
drwxr-xr-x. 13 root     root      4,0K янв 30 02:12 ..
-rw-r--r--.  1 custom_u custom_gr 529K янв 30 02:13 backup_log_30-01-2024_02-13-15.txt
-rw-r--r--.  1 custom_u custom_gr 529K янв 30 02:19 backup_log_30-01-2024_02-19-01.txt
-rw-r--r--.  1 custom_u custom_gr 529K янв 30 02:20 backup_log_30-01-2024_02-20-01.txt
-rw-r--r--.  1 custom_u custom_gr 529K янв 30 02:21 backup_log_30-01-2024_02-21-01.txt
-rw-r--r--.  1 custom_u custom_gr 529K янв 30 02:22 backup_log_30-01-2024_02-22-01.txt
```
На удаленном сервере РК:

```sh
[artys@test1-redos ~]$ ls -la /backups/
итого 22632
drwx------.  2 artys artys    4096 янв 30 01:36 .
dr-xr-xr-x. 19 root  root     4096 янв 30 00:30 ..
-rw-r--r--.  1 artys artys 3307188 янв 30 01:47 docker_bkp_2024-01-30_01-47-25.tgz
-rw-r--r--.  1 artys artys 3307653 янв 30 01:24 docker_bkp_30-01-2024_02-10-40.tgz
-rw-r--r--.  1 artys artys 3307166 янв 30 01:27 docker_bkp_30-01-2024_02-13-15.tgz
-rw-r--r--.  1 artys artys 3307454 янв 30 01:33 docker_bkp_30-01-2024_02-19-01.tgz
-rw-r--r--.  1 artys artys 3307313 янв 30 01:34 docker_bkp_30-01-2024_02-20-01.tgz
-rw-r--r--.  1 artys artys 3307217 янв 30 01:35 docker_bkp_30-01-2024_02-21-01.tgz
-rw-r--r--.  1 artys artys 3307247 янв 30 01:36 docker_bkp_30-01-2024_02-22-01.tgz
```

Проверим, что атрибуты сохраняются:
```sh
 sudo tar --same-owner --selinux --acls --xattrs  -xzf /backups/docker_bkp_30-01-2024_02-22-01.tgz
```
```sh
[artys@test1-redos ~]$ ls -laZ docker
итого 32
drwxrwxr-x. 4 artys artys unconfined_u:object_r:user_home_t:s0     4096 янв 30 02:06 .
drwx------. 8 artys artys unconfined_u:object_r:user_home_dir_t:s0 4096 янв 30 02:06 ..
drwxr-xr-x+ 3 root  root  staff_u:object_r:default_t:s0            4096 янв 30 00:26 app
drwxr-xr-x+ 2 root  root  staff_u:object_r:default_t:s0            4096 янв 30 00:26 db
-rw-r-xr--+ 1 root  root  staff_u:object_r:default_t:s0            1245 янв 30 00:26 docker-compose.yml
```
[лога]: <https://github.com/artysleep/otus-backup-lab/blob/main/backup_log_30-01-2024_02-22-01.txt>
