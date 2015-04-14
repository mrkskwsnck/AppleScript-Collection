(* NOTE: Missing new lines for message of vacation notice! *)

-- BEGIN of Properties
property plist : "de.redrauscher.mail.plist"
property tmp : "de.redrauscher.mail.tmp"
property user_name : missing value
property pass_word : missing value
-- END of Properties

try
	(* Retrieving full path to the property list needed *)
	set propertyListFile to getPathToPropertyListFile(plist)
	set propertyListFile to propertyListFile as alias
	(* end *)
	
	(* Retrieving properties from property list file *)
	tell application "System Events"
		set propertyListFile to POSIX path of propertyListFile
		tell property list file propertyListFile -- POSIX path supported only
			tell contents
				set user_name to value of property list item "username"
				set pass_word to value of property list item "password"
			end tell
		end tell
	end tell
	(* end *)
	
	(* Perform RPCs *)
	set loginAnswer to login(user_name, pass_word)
	if success of loginAnswer as integer is equal to 1 then
		(* Get current settings *)
		set getVacationNoticeAnswer to getVacationNotice(sessionId of loginAnswer)
		
		display dialog "Turn vacation notice on or off?" buttons {"On", "Off"} default button "Off"
		if button returned of result is equal to "On" then
			set enabled to 1
			display dialog "Enter start date in format MM/DD/YYYY:" default answer startDate of getVacationNoticeAnswer
			set startDate to text returned of result
			display dialog "Enter returning date in format MM/DD/YYYY:" default answer endDate of getVacationNoticeAnswer
			set endDate to text returned of result
			display dialog "Enter subject:" default answer subject of getVacationNoticeAnswer
			set subject to text returned of result
			display dialog "Enter message:" default answer message of getVacationNoticeAnswer
			set message to text returned of result
		else
			set enabled to 0
			set startDate to startDate of getVacationNoticeAnswer
			set endDate to endDate of getVacationNoticeAnswer
			set subject to subject of getVacationNoticeAnswer
			set message to message of getVacationNoticeAnswer
		end if
		
		(* Set new settings *)
		set setVacationNoticeAnswer to setVacationNotice(sessionId of loginAnswer, enabled, startDate, endDate, subject, message)
		if setVacationNoticeAnswer is equal to "1" then
			display dialog "Saved!" buttons {"OK"} default button "OK" with icon note
		else
			error "Catastrophic failure" number 42
		end if
	else
		display dialog "Authentification failed!" buttons {"OK"} default button "OK" with title "Catastrophic failure" with icon stop
	end if
	(* end *)
on error m number n
	if n is equal to -43 then
		createPreferences(propertyListFile)
	else if n is equal to -128 then
		display dialog "Cancelled!" buttons {"OK"} default button "OK" with icon note
	else
		display alert m & space & "(" & n & ")"
	end if
end try

-- BEGIN RPC Methods
on login(user_name, pass_word)
	set xml to "<?xml version=\"1.0\"?><methodCall><methodName>login</methodName><params><param><value><string>" & user_name & "</string></value></param><param><value><string>" & pass_word & "</string></value></param></params></methodCall>"
	do shell script "/usr/bin/curl --insecure --data '" & xml & "' https://mail.redrauscher.de/EMAILRULES"
	set answer to result
	
	set tmpFileHandler to open for access "/tmp/" & tmp with write permission
	write answer to tmpFileHandler as Çclass utf8È
	close access tmpFileHandler
	
	set methodAnswer to {sessionId:missing value, displayName:missing value, hasLocalEmail:missing value, success:missing value}
	
	do shell script "/usr/bin/xpath /tmp/" & tmp & " '//methodResponse/params/param/value/struct/member[1]/value/string/text()'"
	set sessionId of methodAnswer to result
	do shell script "/usr/bin/xpath /tmp/" & tmp & " '//methodResponse/params/param/value/struct/member[2]/value/string/text()'"
	set displayName of methodAnswer to result
	do shell script "/usr/bin/xpath /tmp/" & tmp & " '//methodResponse/params/param/value/struct/member[3]/value/boolean/text()'"
	set hasLocalEmail of methodAnswer to result
	do shell script "/usr/bin/xpath /tmp/" & tmp & " '//methodResponse/params/param/value/struct/member[4]/value/boolean/text()'"
	set success of methodAnswer to result
	
	tell application "Finder" to delete POSIX file ("/tmp/" & tmp) as alias
	
	return methodAnswer
end login

on getVacationNotice(sessionId)
	set xml to "<?xml version=\"1.0\"?><methodCall><methodName>getVacationNotice</methodName><params><param><value><string>" & sessionId & "</string></value></param></params></methodCall>"
	
	do shell script "/usr/bin/curl --insecure --data '" & xml & "' https://mail.redrauscher.de/EMAILRULES"
	set answer to result
	
	set tmpFileHandler to open for access "/tmp/" & tmp with write permission
	write answer to tmpFileHandler as Çclass utf8È
	close access tmpFileHandler
	
	set methodAnswer to {startDate:missing value, message:missing value, endDate:missing value, enabled:missing value, subject:missing value}
	
	do shell script "/usr/bin/xpath /tmp/" & tmp & " '//methodResponse/params/param/value/struct/member[1]/value/string/text()'"
	set startDate of methodAnswer to result
	do shell script "/usr/bin/xpath /tmp/" & tmp & " '//methodResponse/params/param/value/struct/member[2]/value/string/text()'"
	set message of methodAnswer to result
	do shell script "/usr/bin/xpath /tmp/" & tmp & " '//methodResponse/params/param/value/struct/member[3]/value/string/text()'"
	set endDate of methodAnswer to result
	do shell script "/usr/bin/xpath /tmp/" & tmp & " '//methodResponse/params/param/value/struct/member[4]/value/boolean/text()'"
	set enabled of methodAnswer to result
	do shell script "/usr/bin/xpath /tmp/" & tmp & " '//methodResponse/params/param/value/struct/member[5]/value/string/text()'"
	set subject of methodAnswer to result
	
	tell application "Finder" to delete POSIX file ("/tmp/" & tmp) as alias
	
	return methodAnswer
end getVacationNotice

on setVacationNotice(sessionId, enabled, startDate, endDate, subject, message)
	set xml to "<?xml version=\"1.0\"?><methodCall><methodName>setVacationNotice</methodName><params><param><value><string>" & sessionId & "</string></value></param><param><value><boolean>" & enabled & "</boolean></value></param><param><value><string>" & startDate & "</string></value></param><param><value><string>" & endDate & "</string></value></param><param><value><string>" & subject & "</string></value></param><param><value><string>" & message & "</string></value></param></params></methodCall>"
	set xml to textReplace("'", space, xml) -- Some characters result in malformed XML document
	
	do shell script "/usr/bin/curl --insecure --data '" & xml & "' https://mail.redrauscher.de/EMAILRULES"
	set answer to result
	
	set tmpFileHandler to open for access "/tmp/" & tmp with write permission
	write answer to tmpFileHandler as Çclass utf8È
	close access tmpFileHandler
	
	set methodAnswer to missing value
	
	do shell script "/usr/bin/xpath /tmp/" & tmp & " '//methodResponse/params/param/value/boolean/text()'"
	set methodAnswer to result
	
	tell application "Finder" to delete POSIX file ("/tmp/" & tmp) as alias
	
	return methodAnswer
end setVacationNotice
-- END RPC Methods

-- BEGIN of Subroutines
(* Returns an alias object to the user's preferences folder *)
on getPreferencesFolder()
	tell application "Finder" to set pathToHomeFolder to path to home folder as text
	set pathToPreferenesFolder to pathToHomeFolder & "Library:Preferences"
	return pathToPreferenesFolder as alias
end getPreferencesFolder

(* Returns the path to the property list file in Mac format as text *)
on getPathToPropertyListFile(plist)
	set preferencesFolder to path to preferences
	set propertyListFile to (preferencesFolder as text) & plist
	return propertyListFile
end getPathToPropertyListFile

(* Create the property list file with the values asked for if not exists *)
on createPreferences(propertyListFile)
	set PropertyListXML to "<?xml version=\"1.0\" encoding=\"UTF-8\"?> <!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\"> <plist version=\"1.0\"> <dict> 	<key>username</key> 	<string></string> 	<key>password</key> 	<string></string> </dict> </plist> "
	set propertyListFileHandler to open for access propertyListFile with write permission
	write PropertyListXML to propertyListFileHandler
	close access propertyListFileHandler
	
	display dialog "Your user name?" default answer ""
	set user_name to text returned of result
	display dialog "Your password?" default answer "" with hidden answer
	set pass_word to text returned of result
	
	set propertyListFile to POSIX path of (propertyListFile as alias)
	tell application "System Events"
		tell property list file propertyListFile
			tell contents
				set value of property list item "username" to user_name
				set value of property list item "password" to pass_word
			end tell
		end tell
	end tell
	display dialog "Saved!" buttons {"OK"} default button "OK" with icon note
end createPreferences

on textReplace(searchTerm, replacement, theText)
	set previousTextItemDelimiters to AppleScript's text item delimiters
	set AppleScript's text item delimiters to searchTerm
	set textItems to text items of theText
	set AppleScript's text item delimiters to replacement
	set returnValue to textItems as text
	set AppleScript's text item delimiters to previousTextItemDelimiters
	return returnValue
end textReplace
-- END of Subroutines
