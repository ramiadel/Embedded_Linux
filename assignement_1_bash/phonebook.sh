#! /bin/bash

clear

File_Name="phonebookDB"

if [ ! -f $File_Name ]
then
        touch $File_Name
        chmod +x $File_Name
        printf "%-20s%-14s\n" "Contact_Name" "Contact_Number">> $File_Name
fi


############WELCOME MESSEGES TO THE USER JUST IN CASE HE/SHE PASSED A WRONG ARGUMENT OR DID NOT PASS ANYTHING############
Insert_Msg="To insert a new contact name and number please, pass [-i]"
View_Msg="To view all saved contacts details please, pass [-v]"
Search_Msg="To search by contact name in the phonebook DB please, pass [-s]"
Delete_All_Msg="To delete all messegs please, pass  [-e]"
Delete_One_Contact_Msg="To delete a certain contact please, pass [-d]"


############THIS FUNCTION ROLE IS TO CHECK IF THE CONTACT'S NAME CONTAINS NOT LITERALS############
function Validate_Contact_Name ()
{
        read -p "Enter a contact's name " Contact_Name
        while  true ;
        do
                if [[ $Contact_Name =~ [0-9] ]]
                then
                        read -p "Please, Enter a valid contact name " Contact_Name
                else
                        break;
                fi
        done
}

############THIS FUNCTION ROLE IS TO CHECK IF THE CONTACT'S NUMBER CONTAINS LITERALS############
function Validate_Contact_Number ()
{
	read -p "Enter the contact's number " Contact_Number
        while true ;
	do
		if [[ $Contact_Number == *[[:alpha:]]* ]]  
		then
			read -p "Please, Enter a valid contact number " Contact_Number
		else 
			break
		fi
        done
}


############THIS FUNCTION ROLE IS TO CHECK IF THERE ARE MULTIPLE CONTACTS WITH THE SAME NAME############
function Validate_Duplicate_Contacts ()
{
	if grep -q $Contact_Name "$File_Name"; then
		echo "DUPLICATED CONTACT !!"
		Duplicated= true
		exit
	fi
}

############THIS FUNCTION ROLE IS TO APPEND A NEW CONTACT TO THE PHONE BOOK DATA BASE############
function Append_To_The_File ()
{
	if $Duplicated ;
	then
		#echo $Contact_Name  $Contact_Number >> $File_Name
		printf "%-20s%-11i\n" "$Contact_Name" "$Contact_Number">> $File_Name
	fi
}

####################THIS FUNCTION IS INVOKED IN 2 CASES EITHER NO OPTION IS PASSED AS AN ARGUMENT OR A WRONG OPTION IS PASSED FROM THE USER####################
function Wrong_Option ()
{
	echo $Insert_Msg
        echo $View_Msg
        echo $Search_Msg
        echo $Delete_All_Msg
        echo $Delete_One_Contact_Msg
}
###########################THIS FUNCTION IS INVOKED TO PRINT THE DATA BASE CONTENT###########################
function Read_The_File ()
{
	while IFS= read -r line
        do
                echo "$line"
        done < $File_Name
        #awk '{print}' $File_Name
}

if [ -z $1 ]
then
##########IF THE USER DID NOT PASS AN OPTION##########
	Wrong_Option
###########IF THE OPTION IS [-i]-----> INSERT A NEW CONTACT INTO THE PHONE BOOK DATA BASE############
elif [ $1 = -i ] 
then
	############VALIDATE FOR THE CONTACT'S NAME TO MAKE SURE IT DOES NOT HAVE ANY NUMBERS############
	Validate_Contact_Name  
	############VALIDATE FOR THE CONTACT'S IF IT'S DUPLICATED#############
	Validate_Duplicate_Contacts
	#############VALIDATE FOR THE CONTACT'S NUMBER IF IT HAS LITERALS IN IT############
	Validate_Contact_Number
	############AFTER MAKING SURE THAT THE INPUT IS LOGICALLY RIGHT INSERT THE RECORD INTO THE DATA BASE############
	Append_To_The_File
  ############IF THE OPTION IS [-v]-----> DISPLAY THE PHONE BBOOK DATA BASE############
elif [ $1 = -v ] 
then
	Read_The_File
  ############IF THE OPTION IS [-s]-----> SEARCH FOR A CONTACT############
elif [ $1 = -s ]
then
	read -p "Please, enter the name you wanna search about " Contact_Name
	############IF THE CONTACT IS FOUND############
	if grep -q $Contact_Name "$File_Name";
	then
		echo "$Contact_Name exists" 
	############IF THE CONTACT IS NOT FOUND############
	else
		echo "$Contact_Name does not exist"
	fi
  ############IF THE OPTION IS [-e]-----> DELETE THE WHOLE DATA BASE############
elif [ $1 = -e ]
then
	echo "" > $File_Name 
  ############IF THE OPTION IS [-d]-----> DELETE A SPECIFIC CONTACT############
elif [ $1 = -d ]
then
	read -p "Please, enter the contact you want to delete " Contact_Name
	############CHECK IF THE CONTACT DOES NOT EXIST IN THE PHONE BOOK DATA BASE############
	if grep -q $Contact_Name "$File_Name"; 
	then
		############IF IT IS FOUND DELETE THE CONTACT NAME AND NUMBER############
		sed -i "/$Contact_Name/d" $File_Name
	else
		############IF NOT DISPLAY AN ERROR MESSAGE TO THE USER############
		echo "You entered a contact that are not exist !!"
	fi
	
#############IF THE OPTION IS NOT ONE OF THE PREVIOUS OPTIONS############
else 
	echo "You entered an invalid option !"
	echo "Please choose one of the following options ^_^"
	Wrong_Option 
fi