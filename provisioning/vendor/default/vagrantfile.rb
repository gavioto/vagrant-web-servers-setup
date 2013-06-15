#
# VARIABLE VALUES
# here you can set the values to override the default values, for this vendor
#
environment   = "dev"      # dev, tst, stg, prd
hostname_ext  = "xpto.com" # will result in app.dev.xpto.com
gituser       = "hgraca"   # the git username from where to clone the projects in the vendor scripts
memory        = "2048"     # the VMs RAM memory

baseBox = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-i386-v20130427.box"

app_box_url      = "#{baseBox}"
db_box_url       = "#{baseBox}"
reports_box_url  = "#{baseBox}"
mailings_box_url = "#{baseBox}"