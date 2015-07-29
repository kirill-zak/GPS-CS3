#!/bin/sh

# Init config
targerPath="$HOME/gps/logs"

# Get source log file path
sourcePath=$1
if [ -z "$sourcePath" ]
	then
	echo "Source path is not specified"
	exit 1

fi

# List all files in source folder
for file in $sourcePath/*.log
do
	# Get year
	logYear=`date -r $file +%Y`
	# Get year and month
	logYearMonth=`date -r $file +%Y-%m`
	# Get date (year, month and day)
	logDate=`date -r $file +%Y-%m-%d`
	
	# Get file name
	#logFileName=`basename $file`

	# Make target path
	logTargerPath="$targerPath/$logYear/$logYearMonth/$logDate/"

	# Get full path to log file
	logFullPath=$logTargerPath`basename $file`

	# Make dir
	mkdir -p $logTargerPath

	# Copy file
	cp $file $logFullPath

	# Convert to gpx
	gpsbabel -i nmea -f $logFullPath -o gpx -F $logFullPath.gpx
done
