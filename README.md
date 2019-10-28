# ADC Installer

Clone onto your server and run `./installer.sh` to install all dependencies and setup your apache2 server to serve the ADC site and API. Note that this will clobber any existing setup, and is meant only for fresh installations of Ubuntu Server 18.04.3, and may fail to run or damage system integrity if run on other operating systems or on modified versions.

If you're using this with ADC hardware, first of all don't do that because all of your passwords and hardware secrets will be public, and second of all the arrays to put the shared secret into the Arduino are stored in `keys.txt`
