# Instance Operations


The program 'instance_op.rb'
can be used to manipulate the instances you created.
Each instance ID is stored in ~/.aws/instances/instance_<name>.json
Where <name> is the name you supllied when you creeated the new instance.
When Using the 'instance_op.rb' use the -N, --instance-name option
to name the JSON file. You only need the <name> part:


```

$ ./instance_op.rb -N ruby2 --describe

```


The name: ruby2 translates into:
~/.aws/instances/instance_ruby2.json



Any operation on an instance be used with the above pattern:
'./instance_op.rb -N <name> --<verb>



The verbs are:


- --start: Start a stopped instance
- --stop: Stop a running instance
- --reboot: Reboot a running instance
- --terminate: Terminate an instance
- --describe: Describe the state of an instance as a hash
- --save: Save the state of the instance, including any IP addresses, in ~/.aws/instances/instance_<name>.json


The '--json' option can be used withe '--describe'
option. Instead of a Ruby hash, you will get a JSON output.


