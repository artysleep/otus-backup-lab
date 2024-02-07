# otus-backup-lab

#Listing from server:
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
