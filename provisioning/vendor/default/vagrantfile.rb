#
# VARIABLE VALUES
# here you can set the values to override the default values, for this vendor
#
environment   = "dev"      # dev, tst, stg, prd
hostname_ext  = "xpto.com" # will result in app.dev.xpto.com
gituser       = "hgraca"   # the git username from where to clone the projects in the vendor scripts
memory        = "2048"     # the VMs RAM memory

baseBoxUrl       = "./boxes/CentOS-6.4-i386-v20130427.box"
app_box_url      = "#{baseBoxUrl}"
db_box_url       = "#{baseBoxUrl}"
reports_box_url  = "#{baseBoxUrl}"
mailings_box_url = "#{baseBoxUrl}"

baseBox          = "CentOS-6.4-i386-v20130427"
app_box          = "#{baseBox}"
db_box           = "#{baseBox}"
reports_box      = "#{baseBox}"
mailings_box     = "#{baseBox}"