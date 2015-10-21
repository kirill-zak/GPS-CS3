#!/bin/sh

############################
## Init config            ##
############################

# Home folder name
homeFolder=".gps-cs3"

# Check configuration file
if [ ! -f "$HOME/$homeFolder/settings.conf" ]; then
	if [ ! -f "settings.default" ]; then
		echo "Default settings not found!"
		exit 1
	fi

	mkdir -p "$HOME/$homeFolder"
	if [ $? -ne 0 ]; then
		echo "Create folder for settings error!"
		exit 1
	fi

	cp "settings.default" "$HOME/$homeFolder/settings.conf"
	if [ $? -ne 0 ]; then
		echo "Create configuration file error!"
		exit 1
	fi
fi

# Load configuration file
. "$HOME/$homeFolder/settings.conf"
if [ $? -ne 0 ];then
	echo "Load configuration file error!"
	exit 1
fi

# Get source log file path
sourcePath=$1
if [ -z "$sourcePath" ]
	then
	echo "Source path is not specified"
	exit 1
fi

#############################
## Check software section  ##
#############################

## grep
grep --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "Grep is not install!"
	exit 1
fi

## GPSBabel
gpsbabel -V > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "GPSBabel is not install!"
	exit 1
fi

#############################
## Work section            ##
#############################

# Get Sony NMEA log files in source path
logFiles=$(grep -rl "^@Sonygps" "$sourcePath")
for file in $logFiles
do
	# Get year
        logYear=`date -r $file +%Y`
        # Get year and month
        logYearMonth=`date -r $file +%Y-%m`
        # Get date (year, month and day)
        logDate=`date -r $file +%Y-%m-%d`
	# File name
	fileName=$(basename "$file")

        # Make target path
        logTargetPath="$logsPath/$logYear/$logYearMonth/$logDate"
	
	# Target file
	logTargetFile="$logTargetPath/$fileName"

        # Make dir
        mkdir -p $logTargetPath

        # Copy file
	cp $file $logTargetFile
	if [ $? -ne 0 ]; then
		echo "Copy file '$fileName': error."
	else
		echo "Copy file '$fileName': OK."
		
		gpsbabel -i nmea -f $logTargetFile -o gpx -F $logTargetFile.gpx
		if [ $? -ne 0 ]; then
			echo "Convert to GPX: error."
		else
			echo "Convert to GPX: OK."
		fi
	fi
done
exit 0
