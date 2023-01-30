Before start export to env credentials
```
  export VES_P12_PASSWORD=<your credential password>
  export VOLT_API_P12_FILE=<path to your local p12 file>
  export VOLT_API_URL=<team or org tenant api url>
```
Change CE flavor by set variable `aws_instance_type  = "t3.xlarge`

Namespace need to be created and name provided `namespace = ptf-test`

AWS credentials stored in F5XC name `aws_cred_name = "aws-creds`




**Depending on scenarion run following commands:**

Local CE without WAF
```
terraform apply -auto-approve -var="waf=false" -var="dccg=false" -var="via-re=false" -var="origin-pool-remote=false"
``` 
Local CE with WAF
```
terraform apply -auto-approve -var="waf=false" -var="dccg=false" -var="via-re=false" -var="origin-pool-remote=false"
``` 
SMG without WAF
```
terraform apply -auto-approve -var="waf=false" -var="dccg=false" -var="via-re=false" -var="origin-pool-remote=true"
``` 
SMG with WAF
```
terraform apply -auto-approve -var="waf=true" -var="dccg=false" -var="via-re=false" -var="origin-pool-remote=true"
``` 
DC CG without WAF
```
terraform apply -auto-approve -var="waf=false" -var="dccg=True" -var="via-re=false" -var="origin-pool-remote=true"
```
DC CG with WAF
```
terraform apply -auto-approve -var="waf=true" -var="dccg=True" -var="via-re=false" -var="origin-pool-remote=true"
``` 
Via RE without WAF
```
terraform apply -auto-approve -var="waf=false" -var="dccg=false" -var="via-re=true" -var="origin-pool-remote=true"
``` 
Via RE with WAF
```
terraform apply -auto-approve -var="waf=true" -var="dccg=false" -var="via-re=true" -var="origin-pool-remote=true"
``` 

