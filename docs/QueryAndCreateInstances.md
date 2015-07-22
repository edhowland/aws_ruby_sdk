# Query and Creating an EC2 Instance

## Programs to use

- bin/query.rb - Query things in AWS
- bin/configure_ec2.rb - Configure EC2 Instance beforecreating one
- bin/ec2_instance.rb - create new EC2 Instance

You use these programs to interact with your AWS account.
You can query resources with query.rb. Your can create and delete ssh key pairs and create a new EC2 instance with ec2_instance.rb.
To do so, you need to create the file: ec2_default.json, which a JSON file
that contains the parameters that describe the new instance.
You can create this file with the program: configure_ec2.rb.


### Options

All three programs are communicated with via command line options.
They all respond to '-h or --help' so you can see which options
they individually take. E.g. to see which U. S. Regions are available:


```
$ cd bin
$ ./query.rb --list-regions
Valid U. S. Region handles:

us-east-1
us-west-1
us-west-2

```

#### Common options

- --region region              Override Region [us-east-1] operates in
- -l, --list-options               Display currently set options

The '--region' option allows you to override the currently set region
set in ~/.aws/region.rb
The '-l' options reports on commonly set parameters such as:
the currently set region and the host access key.


## query.rb

The query.rb program only queries various resources your account have access to, such as:
key pairs, virtual private clouds, security groups, S3 objects and Ec2 instances.
You can list everything with the '-a' or '--list-a' options.


## configure_ec2.rb

The configure_ec2.rb program sets parameters in the 'ec2_default.json' JSON file.
Each parameter is set via a command line option and multiple options can be
be set at the same time. To see a list of the currently set options use the '-d or --display' option.


```

        --region region              Override Region [us-east-1] operates in
    -l, --list-options               Display currently set options

    -y, --dry-run                    Set dry_run parameter
    -n, --no-dryrun                  Unset dry_run parameter
    -k, --key-pair name              Set Key Pair name
    -t, --type name                  Set Instance Type: E.g. t1.micro
    -i, --image name                 Set AMI Image ID
    -m, --min-count name             Set minimun count of instances
    -x, --max-count name             Set maximum instance count
    -g, --security-groups name       Set security group
    -d, --display                    Display currently set EC2 options

```

### --dry-run

You can set the dry_run: parameter for the ec2_instance.rb program. Setting this parameter will
not set or create anything in your AWS account. It will check
to see if all your parameters are set to sensible values
and that you have enough of them set.


## ec2_instance.rb

You can create and delete key pairs with the --create-key and --delete-key options. Each of these require a name of the key pair.


You can create a new EC2 instance with the -n or --new option.
It uses the file: ec2_default.json file. This file can be created
with the configure_ec2.rb program


