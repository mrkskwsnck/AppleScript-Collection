(* Reference: http://hints.macworld.com/article.php?story=20080127172157404 *)

property user_name : "" -- The username
property pass_word : "" -- The password

try
	display dialog "Create or delete hidden administrator?" with title "Hidden administrator management" buttons {"Cancel", "Delete", "Create"} cancel button "Cancel" with icon caution
	if button returned of result is equal to "Create" then
		set command to "/bin/bash '" & POSIX path of (path to resource "create_hidden_administrator_user.sh" in directory "Scripts") & "' " & user_name & space & pass_word
		log command
		do shell script command with administrator privileges
	else if button returned of result is equal to "Delete" then
		set command to "/bin/bash '" & POSIX path of (path to resource "destroy_hidden_administrator_user.sh" in directory "Scripts") & "' " & user_name
		log command
		do shell script command with administrator privileges
	end if
	
	display dialog "You must restart for changes to take effect!" with title "Restart needed" buttons {"OK"} default button "OK" with icon caution
on error m number n
	if n is not equal to -128 then
		beep
		display dialog m with title n buttons {"OK"} default button "OK" with icon stop
	end if
end try
