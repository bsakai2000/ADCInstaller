set -euo pipefail

# Given correct arguments, generates a query that will add a door
# to the database. Dynamically generates MAC addresses and secrets
# as required

# We expect name, location, latitude, and longitude, and can accept mac and key
if [ $# -lt 4 ] || [ $# -gt 6 ]
then
	echo "Wrong number of arguments!"
	echo "Usage: $0 <Door Name> <Door Location> <Latitude> <Longitude> [<mac> [<key>]]"
	exit 1
fi

# Name and location must be alphanumeric, dashes, or underscores
nameLocRegex='^[a-zA-Z0-9_ -]+$'

if ! [[ $1 =~ $nameLocRegex ]]
then
	echo "Invalid Door Name!"
	echo "Door Name and Location must match regex ^[a-zA-Z0-9_ -]+$ (must consist of alphanumeric, -, space, or _ and no other characters)"
	echo "Usage: $0 <Door Name> <Door Location> <Latitude> <Longitude> [<mac> [<key>]]"
	exit 1
fi

if ! [[ $2 =~ $nameLocRegex ]]
then
	echo "Invalid Door Location!"
	echo "Door Name and Location must match regex ^[a-zA-Z0-9-_]+$ (must consist of alphanumeric, -, or _ and no other characters)"
	echo "Usage: $0 <Door Name> <Door Location> <Latitude> <Longitude> [<mac> [<key>]]"
	exit 1
fi

# Latitude and longitude must be numbers, not more than 999 (actually more like
# 180, but that would be a much harder regex and we're only really worried about
# mistakes, not malicious attacks, because this only generates statements
latLongRegex='^-?[0-9]{1,3}(\.[0-9]+)?$'

if ! [[ $3 =~ $latLongRegex ]]
then
	echo "Invalid Latitude!"
	echo "Door Latitude and Longitude must match regex ^-?[0-9]{1,3}(\.[0-9]+)?$ (must be a positive or negative number)"
	echo "Usage: $0 <Door Name> <Door Location> <Latitude> <Longitude> [<mac> [<key>]]"
	exit 1
fi

if ! [[ $4 =~ $latLongRegex ]]
then
	echo "Invalid Longitude!"
	echo "Door Latitude and Longitude must match regex ^-?[0-9]{1,3}(\.[0-9]+)?$ (must be a positive or negative number)"
	echo "Usage: $0 <Door Name> <Door Location> <Latitude> <Longitude> [<mac> [<key>]]"
	exit 1
fi

# If we have our extra arguments, validate them also
if [ $# -gt 4 ]
then
	# MAC address must be of form AB:CD:EF:12:34:56
	macRegex='^([A-F0-9]{2}:){5}[A-F0-9]{2}$'
	if ! [[ $5 =~ $macRegex ]]
	then
		echo "Invalid Mac!"
		echo "Mac must match regex ^([A-F0-9]{2}:){5}[A-F0-9]{2}$ (must be a valid uppercase colon delineated MAC address)"
		echo "Usage: $0 <Door Name> <Door Location> <Latitude> <Longitude> [<mac> [<key>]]"
		exit 1
	fi

	if [ $# -gt 5 ]
	then
		# Key must be 32 byte (256 bit) base32 encoded
		keyRegex='^[A-Z2-7]{52}$'
		if ! [[ $6 =~ $keyRegex ]]
		then
			echo "Invalid Key!"
			echo "Key must match regex ^[A-Z2-7]$ (must consist of 52 characters of Base32 encoding using numbers 2-7 and uppercase letters. 32 bytes decoded)"
			echo "Usage: $0 <Door Name> <Door Location> <Latitude> <Longitude> [<mac> [<key>]]"
			exit 1
		fi
	fi
fi

# Generate first part of statement with required variables
echo 'use users;'
echo -n 'INSERT INTO doors (name, location, latitude, longitude, mac, `key`) VALUES ('
echo -n "\"$1\", \"$2\", \"$3\", \"$4\", "

if [ $# -gt 4 ]
then
	# If we have a MAC, use it
	echo -n "\"$5\", "
else
	# Generate a random compliant MAC
	echo -n '"'
	macArr=(0 1 2 3 4 5 6 7 8 9 A B C D E F)
	for i in {1..5}
	do
		r=$(($RANDOM % 16))
		echo -n ${macArr[$r]}
		r=$(($RANDOM % 16))
		echo -n ${macArr[$r]}
		echo -n ':'
	done
	r=$(($RANDOM % 16))
	echo -n ${macArr[$r]}
	r=$(($RANDOM % 16))
	echo -n ${macArr[$r]}
	echo -n '", '
fi

if [ $# -gt 5 ]
then
	# If we have a key, use it
	echo "\"$6\");"
else
	# Generate a random compliant key using the same
	# PHP library used to validate them, to be sure we
	# don't have any compatibility errors
	echo $1 >> keys.txt
	key=$((php keygen.php 3>&2 2>&1 1>&3) 2>>keys.txt)
	echo "\"$key\");"
fi
