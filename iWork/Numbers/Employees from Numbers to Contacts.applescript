(* Iterate through a Numbers document and fill in contact fields of the AddressBook *)

property odHost : "" -- The Open Directory host
property theUsername : "" -- Default: diradmin
property thePassword : "" -- Do not commit password!

try
	tell application "Numbers" to tell front document to tell sheet 1 to tell table 1
		repeat with currentRow in rows
			repeat 1 times
				(* Skip first row *)
				if address of currentRow = 1 then
					exit repeat
				end if
				
				set shortName to (value of cell ("C" & address of currentRow))
				set phone to (value of cell ("D" & address of currentRow))
				if class of phone ­ text then
					(* Skip if no PhoneNumber is present *)
					exit repeat
				end if
				set mobile to (value of cell ("E" & address of currentRow))
				if class of mobile ­ text then
					(* Skip if no MobileNumber is present *)
					exit repeat
				end if
				
				(* Prepare for setting the PhoneNumber *)
				set shellCommand to "/usr/bin/dscl -u " & theUsername & " -P " & thePassword & " /LDAPv3/" & odHost & " -create /Users/" & shortName & " PhoneNumber " & phone
				--do shell script shellCommand
				log shellCommand
				
				(* Prepare for setting the MobileNumber *)
				set shellCommand to "/usr/bin/dscl -u " & theUsername & " -P " & thePassword & " /LDAPv3/" & odHost & " -create /Users/" & shortName & " MobileNumber " & mobile
				--do shell script shellCommand
				log shellCommand
			end repeat
		end repeat
	end tell
on error m number n
	(* Pass through *)
	error m number n
end try
