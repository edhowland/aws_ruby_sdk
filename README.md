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


