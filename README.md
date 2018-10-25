# vvv-provision-test

A repo to test VVV provisioning

## Set up

* Clone this repo somewhere
* Install VVV somewhere and add a test site to vvv-custom.yml` with the following line:

```
  provisioning-script_vvv:
    repo: git@github.com:markbain/vvv-provision-test.git
    hosts: 
      - provisioning-script_vvv.test
```

* Make changes and push them
* Once you've pushed changes, you can run `vagrant reload --provision` in your VM to test. 
* Have fun!
