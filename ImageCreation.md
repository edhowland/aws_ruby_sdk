# Image Creation

## Abstract


You can create a new image from an existing EC2 instance.
You might want to do this after installing packages and apllications
in your existing instance.
You should stop the instance first. See the CreateEC2 guide.


```

$ ./ec2_instance.rb -i i-xxxx # the instnce if

```


The state of the new image will be 'pending'.
It might take many minutes or even hours to come up.
You can query this image with:


```

$ ./query.rb -i ami-xxxxx # the image id from the last step

```


Once the image is listed as 'Available',
add the ami id to the ec2_default.json:


```

$ ./configure_ec2.rb -i ami-xxxxxx # the ami id 

```


Next, create the new instance.


```

$ ./ec2_instance -n

```

## Finishing up


Use the instrunctions in CreateEC2 to queryy, stop, start, reboot and terminate the instance


