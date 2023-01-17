#!/usr/bin/env python3
import argparse
import json
import subprocess
import sys


def parse_args():
    parser = argparse.ArgumentParser(description="YC inventory script")
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('--list', action='store_true')
    group.add_argument('--host')
    group.add_argument('--test', action='store_true')
    return parser.parse_args()

def get_yc_running_vms():
    res = {'app' : ['appserver'], 'db' : ['dbserver'] }

    return res

def get_host_details(host):
    if host == 'reddit-app':
        ip = '51.250.5.20'
    else:
        ip = '51.250.8.183'

    return {'ansible_ssh_host': ip}

def get_group_from_name(name, rel):
    key = name.replace("reddit-","")
    if key in rel.keys():
        return rel[key]
    else:
        return "other"

def get_yc_instances():
    cmd = "yc compute instance list --format json"
    status = subprocess.check_output(cmd.split()).rstrip()
    compute_instance_list = json.loads(status)

    hostvars = {}
    hosts = {"all":[], "db":[], "app": [], "other": []}
    name_group_rel = {"db": "db", "app": "app"}
    for instance in compute_instance_list:
        host_name = instance['name']
        group = get_group_from_name(host_name, name_group_rel)
        hosts[group].append(host_name)
        hosts["all"].append(host_name)
        host_ip = instance['network_interfaces'][0]['primary_v4_address']['one_to_one_nat']['address']
        hostvars[host_name] = {'ansible_ssh_host': host_ip}

    res = {'_meta': {'hostvars': hostvars}} | hosts
    return res

def main():
    args = parse_args()
    if args.list:
        hosts = get_yc_instances()
        json.dump(hosts, sys.stdout)
    elif args.host:
        details = get_host_details(args.host)
        json.dump(details, sys.stdout)
    else:
        print(get_yc_instances())

if __name__ == '__main__':
    main()
