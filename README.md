# tf-random
Terraform random provider demo

# Random provider

The "random" provider allows the use of randomness within Terraform configurations. This is a logical provider, which means that it works entirely within Terraform's logic, and doesn't interact with any other services.

Unconstrained randomness within a Terraform configuration would not be very useful, since Terraform's goal is to converge on a fixed configuration by applying a diff. Because of this, the **"random" provider provides an idea of managed randomness**: it provides resources that generate random values during their creation and then hold those values steady until the inputs are changed. 



# todo
[ ] intro
[ ] example code
[ ] update Readme

# done

[x] initial readme
