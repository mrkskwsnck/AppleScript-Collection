(* URL: http://support.apple.com/kb/HT2577 *)

try
	(* Drag the Remote Desktop application to the Trash. *)
	try
		(* Skip this try block if the application is not present! *)
		set ardApp to (path to applications folder as text) & "Remote Desktop.app" as alias
		tell application "Finder" to delete ardApp
		display dialog "Empty the trash before you proceed!"
	end try
	
	try
		set privilegedCompoundCommand to "rm -rf /var/db/RemoteManagement"
		set privilegedCompoundCommand to privilegedCompoundCommand & "; rm /Library/Preferences/com.apple.RemoteDesktop.plist"
		set privilegedCompoundCommand to privilegedCompoundCommand & "; rm -r /Library/Application\\ Support/Apple/Remote\\ Desktop/"
		log "# " & privilegedCompoundCommand
		do shell script privilegedCompoundCommand with administrator privileges
		
		set compoundCommand to "rm ~/Library/Preferences/com.apple.RemoteDesktop.plist"
		set compoundCommand to compoundCommand & "; rm -r ~/Library/Application\\ Support/Remote\\ Desktop/"
		log "$ " & compoundCommand
		do shell script compoundCommand
	end try
	
	beep
on error m number n
	display dialog m with title n buttons {"OK"} default button "OK" with icon 0
end try