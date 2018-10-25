# vvv-provision-test

A custom VVV provisioning script. 

This repo can be used as-is as the provisioner to jump-start **new** VVV projects. Once started, though, the provisioning script should be committed to the new project repo. 

## Set up

* Clone this repo somewhere
* Install VVV somewhere and add a test site to `vvv-custom.yml` with the following line:

```
  provisioning-script_vvv:
    repo: git@github.com:markbain/vvv-provision-test.git
    hosts: 
      - provisioning-script_vvv.test
```

* Make changes and push them
* Once you've pushed changes, you can run `vagrant reload --provision` in your VM to test. 
* Have fun!
