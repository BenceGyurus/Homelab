## Directory structure

```text
/ansible
├── /inventory
│   ├── 
│   ├── production.ini     # global vars for example: hosts, usernames to hosts etc.
│
├── /public
│   ├── haproxy.cfg        # haproxy config of public
│   ├── firewall.yml       # ansible file that set the opend firewall ports
│
├── /router
│   ├── router.yml         # I haven't made it yet :(
│
├── /torrent
│   ├── permissions.yml    # set users permissions
│   ├── users.yml          # creates specific users
│
├── site.yml               # playbook file          
└── README.md
```

## Run

```shell
ansible-playbook public/*.yml -i inventory
```

use the -i flag to set the inventory folder. This command will run all .yml files located in the public folder

to run a specific file, just replace public/*.yml with the relative path to your file