# AWS Ruby SDK

## abstract

Experimenting with AWS Ruby SDK. 
Query available resources, etc.


## Configuration

The AWS SDK can look for secret credentials in a few places.
It prefers the enviroment. Therefore, currently this code
looks in ~/.aws/credentials.rb. where the enviroment
is set via the ENV hash.


The method load_credentials can be set to load from JSON file or other methods.
Currently, it justs requires the ~/.aws/credentials.rb file.


### Regions

AWS also requires that Region be set via tne enviroment.
Therefore, this code looks for the file: ~/.aws/region.rb
Just with credentials, you can adjust the method via the environment is set.
Currently, it just requires those files.
Later, it can be set from a JSON or vial external shell script


## Setup

Before starting, run Bundler first to load the aws-sdk-resources gem if not 
already installed.


```
$ bundle

```

### First code

Once you have set your credentials and region in ~/.aws, you need to load into the environment.
You can do this by requiring lib/application.rb:


```
require 'lib/application'

# call something like:
# ec2 = Aws::EC2::Resource.new

```

## Running a query

The file: bin/query.rb will attempt to check if any instances of EC2 
exist. For now, only EC2 resourcesare checked.


