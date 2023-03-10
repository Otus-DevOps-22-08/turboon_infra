#!/usr/bin/env python

from ansible.plugins.inventory import BaseInventoryPlugin
from yandexcloud import SDK

class InventoryModule(BaseInventoryPlugin):
    NAME = 'yc_inventory'

    def __init__(self):
        super().__init__()

    def verify_file(self, path):
        return path.endswith(('yc.yaml', 'yc.yml'))

    def parse(self, inventory, loader, path, cache):
        self.inventory = inventory
        self.sdk = SDK()
        self.path = path

        with open(path) as f:
            yc_config = yaml.safe_load(f)

        for group in yc_config.get('groups', []):
            group_name = group['name']
            self.inventory.add_group(group_name)

            for host in group['hosts']:
                host_name = host['name']
                self.inventory.add_host(host_name, group=group_name)

                # Set host variables
                self.inventory.set_variable(host_name, 'ansible_host', host['address'])

                # Set group variables
                for key, value in group.get('vars', {}).items():
                    self.inventory.set_variable(group_name, key, value)
