# tf-random
Terraform random provider demo

# Requirements
This repo assumes general knowledge about Terraform for AWS, if not, please get yourself accustomed first by going through [getting started guide](https://learn.hashicorp.com/terraform?track=getting-started#getting-started) . Please also have your AWS credentials prepared in some way, preferably environment variables. See in details here : [Section - Keeping Secrets](https://aws.amazon.com/blogs/apn/terraform-beyond-the-basics-with-aws/)


# Random provider

The "random" provider allows the use of randomness within Terraform configurations. This is a logical provider, which means that it works entirely within Terraform's logic, and doesn't interact with any other services.

Unconstrained randomness within a Terraform configuration would not be very useful, since Terraform's goal is to converge on a fixed configuration by applying a diff. Because of this, the **"random" provider provides an idea of managed randomness**: it provides resources that generate random values during their creation and then hold those values steady until the inputs are changed. 

Provider has following resources:
- random_id
- random_integer
- random_password
- random_pet
- random_shuffle
- random_string
- random_uuid

The resources **all provide a map argument called keepers** that can be populated with arbitrary key/value pairs that should be selected such that they remain the same until new random values are desired. E.g. this i

Let's walk over short description of features of each and every resource, and then we going to check the example.

### random_id
Original manual can be found [here](https://www.terraform.io/docs/providers/random/r/id.html)
This generates random numbers that are intended to be used as unique identifiers for other resources. it *does use a cryptographic random number generator* in order to minimize the chance of collisions, making the results of this resource when a 16-byte identifier is requested of equivalent uniqueness to a type-4 UUID.
This resource can be used in conjunction with resources that have the `create_before_destroy` lifecycle flag set, to avoid conflicts with unique names during the brief period where both the old and new resources exist concurrently.

The following arguments are supported:
- byte_length - (Required) The number of random bytes to produce. The minimum value is 1, which produces eight bits of randomness.
- prefix - (Optional) Arbitrary string to prefix the output value with. This string is supplied as-is, meaning it is not guaranteed to be URL-safe or base64 encoded.

The following attributes are exported:
- b64_url - The generated id presented in base64, using the URL-friendly character set: case-sensitive letters, digits and the characters _ and -.
- b64_std - The generated id presented in base64 without additional transformations.
- hex - The generated id presented in padded hexadecimal digits. This result will always be twice as long as the requested byte length.
- dec - The generated id presented in non-padded decimal digits.

### random_integer
Original manual can be found [here](https://www.terraform.io/docs/providers/random/r/integer.html)
This resource generates random values from a given range, described by the min and max attributes of a given resource.

This resource also can be used in conjunction with resources that have the `create_before_destroy` lifecycle flag set, to avoid conflicts with unique names during the brief period where both the old and new resources exist concurrently.
The following arguments are supported:
- min - (int) The minimum inclusive value of the range.
- max - (int) The maximum inclusive value of the range.
- seed - (Optional) A custom seed to always produce the same value.

The following attributes are supported:
- id - (string) An internal id.
- result - (int) The random Integer result.

### random_string 

Original manual can be found [here](https://www.terraform.io/docs/providers/random/r/string.html)
This resource generates a random permutation of alphanumeric characters and optionally special characters and does use a cryptographic random number generator.

Historically this resource's intended usage has been ambiguous as the original example used it in a password. For backwards compatibility it will continue to exist. For unique ids please use [random_id](#random_id), for sensitive random values please use [random_password](#random_password).

The following arguments are supported:

-  length - (Required) The length of the string desired
-  upper - (Optional) (default true) Include uppercase alphabet characters in random string.
-  min_upper - (Optional) (default 0) Minimum number of uppercase alphabet characters in random string.
-  lower - (Optional) (default true) Include lowercase alphabet characters in random string.
-  min_lower - (Optional) (default 0) Minimum number of lowercase alphabet characters in random string.
-  number - (Optional) (default true) Include numeric characters in random string.
-  min_numeric - (Optional) (default 0) Minimum number of numeric characters in random string.
-  special - (Optional) (default true) Include special characters in random string. These are `!@#$%&*()-_=+[]{}<>:?`
-  min_special - (Optional) (default 0) Minimum number of special characters in random string.
-  override_special - (Optional) Supply your own list of special characters to use for string generation. This overrides the default character list in the special argument. The special argument must still be set to true for any overwritten characters to be used in generation.

Exports only one attribute : 
- result - Random string generated.


### random_password
Original manual can be found [here](https://www.terraform.io/docs/providers/random/r/password.html) 
> Note: Requires random provider version >= 2.2.0

Identical to random_string above, with the exception that the result is treated as sensitive and, thus, not displayed in console output.

> Note: All attributes including the generated password will be stored in the raw state as plain-text. Please [read here about sensitive data in the stat](https://www.terraform.io/docs/state/sensitive-data.html)

All arguments of the [random_string](#random_string) supporter

And it exports only one attribute : 
- `result` - Random string generated.

### random_pet
Original manual can be found [here](https://www.terraform.io/docs/providers/random/r/pet.html)
This resource generates random pet names that are intended to be used as unique identifiers for other resources. ( Think of server names, clusters, instances names etc..)
This resource can be used in conjunction with resources that have the create_before_destroy lifecycle flag set, to avoid conflicts with unique names during the brief period where both the old and new resources exist concurrently.

The following arguments are supported:
- `length` - (Optional) The length (in words) of the pet name.
- `prefix` - (Optional) A string to prefix the name with.
- `separator` - (Optional) The character to separate words in the pet name.

Exports only one attribute : 
- `id` - (string) The random pet name


### random_shuffle
Original manual can be found [here](https://www.terraform.io/docs/providers/random/r/shuffle.html)
This resource generates a random permutation of a list of strings given as an argument.

The following arguments are supported:
- `input` - (Required) The list of strings to shuffle.
- `result`_count - (Optional) The number of results to return. Defaults to the number of items in the input list. If fewer items are requested, some elements will be excluded from the result. If more items are requested, items will be repeated in the result but not more frequently than the number of items in the input list.
- `seed` - (Optional) Arbitrary string with which to seed the random number generator, in order to produce less-volatile permutations of the list. Important: Even with an identical seed, it is not guaranteed that the same permutation will be produced across different versions of Terraform. This argument causes the result to be less volatile, but not fixed for all time.

Exports only one attribute : 
- `result` - Random string generated.

### random_uuid
Original manual can be found [here](https://www.terraform.io/docs/providers/random/r/uuid.html)
This resource generates random uuid string that is intended to be used as unique identifiers for other resources.

This resource uses the hashicorp/go-uuid to generate a UUID-formatted string for use with services needed a unique string identifier.

The resource does not support any arguments except `keepers`, and exports only `result` attribute

> Note - Random UUID's can be imported. This can be used to replace a config value with a value interpolated from the random provider without experiencing diffs.

For example: `$ terraform import random_uuid.main aabbccdd-eeff-0011-2233-445566778899`

# Example of random resources usage 

We are going to create an example that starts and AWS EC2 micro instance, that is getting random server name suffix each time AMI is changed, and also contains some randomly generated or randomly shuffled tags (for geo-region). This is purely demonstrational example, but, for example , sync of using random_shuffle - for specifying for ELB 2 zone out of 5,
and so on.
The 3 resource that are NOT demonstrated in he example belows are `random_string`, `random_uuid` and `random_pet`, the first one - because `random_password` mostly duplicates its functionality ,and, hidden in console; and last one - is demonstrated in a separate repo [here](https://github.com/Galser/tf-random-pet). As for the `random_uuid` - its usage is straight-forward and will be provided also in a separate repo, together with `random_pet`. 

- Let's create our infrastructure, please put the code below in the file `main.tf`
    ```terraform
    variable "ami_id" {
      default = "ami-048d25c1bda4feda7" # Ubuntu 18.04.3 Bionic, custom
    }

    # AWS provider
    provider "aws" {
      profile    = "default"
      region     = "eu-central-1"
    }

    resource "random_id" "server" {
      keepers = {
        # Generate a new id each time we switch to a new AMI id
        ami_id = "${var.ami_id}"
      }
      byte_length = 8
    }

    resource "random_password" "password" {
      length = 16
      special = true
      override_special = "_%@"
    }

    resource "random_shuffle" "separation_zone" {
      input = ["europe", "asia", "us", "australia", "antarctica"]
      result_count = 1 # return only ONE zone
    }

    resource "random_integer" "subzone" {
      min     = 1
      max     = 3
    }

    resource "aws_instance" "randomexample" {
      # Read the AMI id "through" the random_id resource to ensure that
      # both will change together.
      ami = "${random_id.server.keepers.ami_id}"

      instance_type = "t2.micro"

      tags = {
        "name" = "randomexample-${random_id.server.hex}"
        "future_password" = random_password.password.result
        "zone" = "${element(random_shuffle.separation_zone.result,0)}"
        "subzone" = "${random_integer.subzone.result}"
      }
    }

    output "server_tags" {
      value = "${aws_instance.randomexample.tags}"
    }
    ```
- Init Terraform with : 
    ```
    terraform init
    ```
- Now, let's run apply for our code :
    ```
    terraform.apply
    ```
    And reply `yes`
- Output going to look similar to : 
    ```
    An execution plan has been generated and is shown below.
    Resource actions are indicated with the following symbols:
    + create

    Terraform will perform the following actions:

    # aws_instance.randomexample will be created
    + resource "aws_instance" "randomexample" {
        + ami                          = "ami-048d25c1bda4feda7"
        + arn                          = (known after apply)
        + associate_public_ip_address  = (known after apply)
    ...
    random_shuffle.separation_zone: Creating...
    random_id.server: Creating...
    random_integer.subzone: Creating...
    random_password.password: Creating...
    random_integer.subzone: Creation complete after 0s [id=3]
    random_id.server: Creation complete after 0s [id=OyQjiAtzJPg]
    random_shuffle.separation_zone: Creation complete after 1s [id=-]
    random_password.password: Creation complete after 1s [id=none]
    aws_instance.randomexample: Creating...
    aws_instance.randomexample: Still creating... [10s elapsed]
    aws_instance.randomexample: Still creating... [20s elapsed]
    aws_instance.randomexample: Creation complete after 22s [id=i-0aa6b07cfc771e7bc]

    Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

    Outputs:

    server_tags = {
      "future_password" = "qhs@cS69dCKr16%8"
      "name" = "randomexample-3b2423880b7324f8"
      "subzone" = "3"
      "zone" = "australia"
    }
    ```
    Now, here as you can see we have 4 "random" values populated in tag.
    Some are very useful, for example *unique* name "randomexample-3b2423880b7324f8", some are less, and displaying passwords like this is not recommended in normal course of events. 
    This is only been provided as an exercise.
-  Do not forget to free-up resource, when they do not needed anymore, by running : 
    ```
    terraform destroy
    ```
    And replying `yes` to the question

This concludes the section.    


# todo
[ ] update Readme

# done

[x] initial readme
[x] intro
[x] example code
