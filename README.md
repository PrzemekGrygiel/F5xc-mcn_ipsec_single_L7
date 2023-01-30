Possible combination to run

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

