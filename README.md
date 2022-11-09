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
bastion_IP = 51.250.8.129
someinternalhost_IP = 10.128.0.21
