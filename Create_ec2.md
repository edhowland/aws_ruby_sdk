# Creating an EC2 Instance


To create a new instance, you have to do several steps first. 
You will need a ssh key pair and a JSON configuration file.
Here are the steps in order:


1. Generate a key pair on your local machine
2. Import it to AWS and give it a name
3. Configure the ec2_default.json and add the key pair name
4. Then spin up the new instance

## Generate a key pair on your local machine


There is an shell script that sets the correct parameters for you: gen-key.sh


```

$ cd bin
$ ./gen-key.sh key_name

```

## Import key Pair into AWS

Use the import_key.rb program to do the gob for you. You will need a name for the pair.

```

$ ./import_key -f ~/ssh/key_name.pub -n key_name

```

## Configure the ec2_default.json and add the key pair name


The existing file ec2_default.json is prepared with a simple t1.micro instance.
All you need to do is add your key pair name you created in
the prvious sstep.


```

$ ./configure_ec2.rb -k key_name
# now inspect the JSON file:
./configure_ec2.rb -d

```

## Then spin up the new instance


Once the JSON looks correct, you can create a new instance by:


```

$ ./ec2_instance.rb -n
# it pprints the new ID of the EC2 instance

```

## Now log in


Use the query program to get the public IP and check the state of the instance.


```

$ ./query.rb --describe-ec2 id-of-instance

# record the IP

```

Now log in:

```

$ ./ssh-login.sh dotted.ip.address.value key_name

```


The key_name is the file name of the private key you genereated above.
The sssh-login.sh program will use the ubuntu name as the user.
Once you are logged in, use 'logout' to logout.


```

# get and record public ip of instance:
./query.rb --describe-ec2 i-xxxxx # instance id
# public IP: 55.xxx.xx.xxx

# login
$ ./ssh-login.sh 55.XX.XX.XXXkey_name

```

## Rebooting the instance


The EC2 instance can be rebooted if it is running.


```

$ ./ec2_instance.rb --reboot-ec2 i-xxxx # the instance id

```

## Cleaning up


You can stop, restart the instance and terminate it.
You will need the instance ID for these actions.
If you did not record it, you can by enumerating all the ec2 instances in your region:


```

$ ./query.rb -e

```

```

## to stop an instance:
$ ./ec2_instance.rb -p instance-id

# To start it
$ ./ec2_instance.rb -s instance-id

# to terminate it
$ ./ec2_instance.rb -t instance-id

```

