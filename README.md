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


