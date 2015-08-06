#!/bin/bash
# init-json.sh - init json storage dir

mdir()
{
  echo Creating dir: $1
  mkdir -p $1 
}

mfile()
{
  echo creating file: $1
  ruby -r json -e "File.write('$1', {}.to_json)"
  echo Now run ./config_ec2.rb --init-settings 
  echo     to set initial defaults in $1
}

dir=~/.aws
idir=$dir/instances
default=$idir/ec2_default.json

[ -d $idir ] || mdir $idir

[ -f $default ] || mfile $default 

