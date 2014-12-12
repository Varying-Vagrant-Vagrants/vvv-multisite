# vvv-multisite

> Provision WordPress multisite installations on your VVV

## Getting Started
1. Set up your environment with all the requirements for [VVV]() - Follow points 1. - 6. of [The First Vagrant Up](https://github.com/Varying-Vagrant-Vagrants/VVV#the-first-vagrant-up)
2. Clone/DL this repo into `/www/vvv-multisite`
3. Provision!

## Provided Sites

#### WordPress Multisite Stable
* LOCAL PATH: vagrant-local/www/wpmu-default
* VM PATH: /srv/www/wpmu-default
* Multisite Type: __subdomain__
* URLs:
  * Network URL: `http://wpmu.dev`
  * Sites:
    * `http://site2.wpmu.dev`
    * `http://site3.wpmu.dev`
    * `http://site4.wpmu.dev`
    * `http://site5.wpmu.dev`
    * `http://site6.wpmu.dev` (only domain routing)
    * `http://site7.wpmu.dev` (only domain routing)
    * `http://site8.wpmu.dev` (only domain routing)
    * `http://site9.wpmu.dev` (only domain routing)
* DB Name: `wpmu_default`

#### WordPress Multisite Trunk
* LOCAL PATH: vagrant-local/www/wpmu-trunk
* VM PATH: /srv/www/wpmu-trunk
* Multisite Type: __subdomain__
* URLs:
  * Network URL: `http://wpmu-trunk.dev`
  * Sites:
    * `http://site2.wpmu-trunk.dev`
    * `http://site3.wpmu-trunk.dev`
    * `http://site4.wpmu-trunk.dev`
    * `http://site5.wpmu-trunk.dev`
    * `http://site6.wpmu-trunk.dev` (only domain routing)
    * `http://site7.wpmu-trunk.dev` (only domain routing)
    * `http://site8.wpmu-trunk.dev` (only domain routing)
    * `http://site9.wpmu-trunk.dev` (only domain routing)
* DB Name: `wpmu_trunk`

#### @todo :: WordPress Multisite Develop
* LOCAL PATH: vagrant-local/www/wpmu-develop
* VM PATH: /srv/www/wpmu-develop
* /src URL: `http://src.wpmu-develop.dev`
* /build URL: `http://build.wpmu-develop.dev`
* DB Name: `wpmu_develop`
* DB Name: `wpmu_unit_tests`

## Copyright / License
vvv-multisite is copyright (c) 2014, the contributors of the VVV project under the [MIT License](https://github.com/Varying-Vagrant-Vagrants/vvv-multisite/blob/master/LICENSE).
