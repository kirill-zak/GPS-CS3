#!/bin/sh

###############
# Init config #
###############

# Set target path
targetPath="$HOME/gps/logs"

# Get source log file path
sourcePath=$1
if [ -z "$sourcePath" ]
	then
	echo "Source path is not specified"
	exit 1

fi

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
        logTargetPath="$targetPath/$logYear/$logYearMonth/$logDate"
	
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
