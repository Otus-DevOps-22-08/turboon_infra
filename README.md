# turboon_infra
turboon Infra repository

# SSH one-line connection
Команда для подключения к someinternalhost: *ssh -i yac -J appuser@51.250.8.129 appuser@10.128.0.21*

Для подключения к someinternalhost простой командой *ssh someinternalhost* надо добавить в ~/.ssh/config следующие строки:

```
Host bastion
        HostName 51.250.8.129
        Port 22
        User appuser
        IdentityFile ~/.ssh/yac
Host someinternalhost
        HostName 10.128.0.21
        Port 22
        User appuser
        IdentityFile ~/.ssh/yac
        ProxyJump bastion
```
# Данные для подключения
```
HW3
bastion_IP = 51.250.8.129
someinternalhost_IP = 10.128.0.21

HW4
testapp_IP = 51.250.86.89
testapp_port = 9292
```

# Команда для автоматизированного создания ВМ, деплоя и запуска reddit-app

```
yc compute instance create --name reddit-app --hostname reddit-app --memory=4 --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4,nat-address=51.250.86.89 --metadata serial-port-enable=1 --metadata-from-file user-data=.\cloud-init
```

# Для создания образа reddit-full в Yandex.Cloud:
* Установите packer
* Укажите верные значения переменных в файле variables.json по примеру из файла variables.json.example
* Выполните команду packer build -var-file=variables.json immutable.json

# Команда для запуска приложения Reddit в Yandex.Cloud на основе собранного образа
```
yc compute instance create --name reddit-app --hostname reddit-app --memory=4 --create-boot-disk image-folder-id=b1gpuerdiskoiae481fe,image-family=reddit-full,size=10GB --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 --metadata serial-port-enable=1 --ssh-key /.ssh/yac.pub
```
Или см. скрипт create-reddit-vm.sh в папке config-scripts
