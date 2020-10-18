#!/bin/bash

addToRecord()
{
	echo
	while true
	do
		echo "To add a record to your address book, Enter information in this"
		echo "format: \"Last name,first name,email,,city,zip-code,phone number\" (no quotes or spaces)."
		echo "Example: kumar,vamsee,vamsee@gmail.com,kurnool,zip-code,8499908290"
		echo "If you'd like to quit, enter 'q'."
		read aInput
		if [ "$aInput" == 'q' ]
			then
			break
		fi
		echo
		echo $aInput >> addressbook.csv
		echo "The entry was added to your address book."
		echo
	done
}

displayRecord()
{
	echo
	while true
	do
		echo "To display a record, enter the last name of the person (case sensitive)."
		echo "If you'd like to quit, enter 'q'."
		read dInput
		if [ "$dInput" == 'q' ]
			then
			break
		fi
		echo
		echo "Listing records for \"$dInput\":"
		grep ^"$dInput" addressbook.csv   # searching the lines by last name (the first field in the record)
		STATUS=`echo $?`
		if [ $STATUS -eq 1 ]
			then
			echo "No records found with last name of \"$dInput\"."
		fi
		echo
	done
}

editRecord()
{
	echo
	while true
	do
		echo "To edit a record, enter any search string, e.g. last name or email address (case sensitive)."
		echo "If you're done editing your address book, enter 'q' to quit."
		read eInput
		if [ "$eInput" == 'q' ]
			then
			break
		fi
		echo
		echo "Listing records for \"$eInput\":"
		grep -n "$eInput" addressbook.csv
		STATUS=`echo $?`
		if [ $STATUS -eq 1 ]
			then
			echo "No records found for \"$eInput\""
		else
			echo
			echo "Enter the line number (the first number of the entry) that you'd like to edit."
			read lineNumber
			echo
			for line in `grep -n "$eInput" addressbook.csv`
			do
				number=`echo "$line" | cut -c1`
				if [ $number -eq $lineNumber ]
					then
					echo "What would you like to change it to? Use the format:"
					echo "\"Last name,first name,email,city,zip-code,phone number\" (no quotes or spaces)."
					read edit
					lineChange="${lineNumber}s"
					sed -i -e "$lineChange/.*/$edit/" addressbook.csv
					echo
					echo "The change has been made."
				fi
			done
		fi
		echo
	done
}

removeRecord()
{
	echo 
	while true
	do
		echo "To remove a record, enter any search string, e.g. last name or email address (case sensitive)."
		echo "If you're done, enter 'q' to quit."
		read rInput
		if [ "$rInput" == 'q' ]
			then
			break
		fi
		echo
		echo "Listing records for \"$rInput\":"
		grep -n "$rInput" addressbook.csv
		STATUS=`echo $?`
		if [ $STATUS -eq 1 ]
			then
			echo "No records found for \"$rInput\""
		else
			echo
			echo "Enter the line number (the first number of the entry) of the record you want to remove."
			read lineNumber
			for line in `grep -n "$rInput" addressbook.csv`
			do
				number=`echo "$line" | cut -c1`
				if [ $number -eq $lineNumber ]
					then
					lineRemove="${lineNumber}d"
					sed -i -e "$lineRemove" addressbook.csv
					echo "The record was removed from the address book."
				fi
			done
		fi
		echo
	done
}

sorting()
{

 echo $(cat addressbook.csv | sort |awk '{print $0}')





}

echo
lastCharOfFile=`tail -c 1 addressbook.csv` # checking to make sure the .csv file ends with newline character
if [ -n "$lastCharOfFile" ]
	then
	echo >> addressbook.csv
fi
echo "what would you like to do with your address book?"
echo "Enter Accordingly:"
echo "1) to add a record"
echo "2) to display 1 or more records"
echo "3) to edit a record"
echo "4) to remove a single record"
echo "5) to Sort"
echo
read input

case $input in
	1) addToRecord
		;;
	2) displayRecord
		;;
	3) editRecord
		;;
	4) removeRecord
		;;
	5) sorting
		;;
	*) echo "Enter Valid number"
		;;

esac

