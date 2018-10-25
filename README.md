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

## Custom webroot

By default, this script will install your site in `public_html`. 

If you want to change this, perhaps because you are working with an existing project that uses another directory as the webroot, you can change where this script installs WordPress. 

* Before provisioning for the first time, create `/vagrant/www/custom-configs/${VVV_SITE_NAME}.conf`
* Add `WEBROOT="htdocs"`
