(* Build a store address list file for importing into Konica Minolta bizhub C284/C454 Multi Functional Peripherals to use for Scan2Mail functionality, where the addresses are being read from Open Directory running on a Mac OS X Server 10.6 Snow Leopard.

Definition of the store address list document recognized by reverse engineering:
¥ Encoding=UTF-16LE with BOM (U+FFFE), 
¥ Line delimiter=CRLF
Considering UTF-16 AppleScript can only write files with UTF-16BE, so the file will be converted afterwards to UTF-16LE. *)

property ldapHost : "directory.example.com"
property mailDomain : "example.com"

property mfpDevices : {"C284", "C454"}
property excludedUsers : {"_ldap_replicator", "diradmin", "root", "vpn_0d23b80a1426", "vpn_b7e4c54dd6ac"}
property searchKeys : {"Abc", "Def", "Ghi", "Jkl", "Mno", "Pqrs", "Tuv", "Wxyz"} -- Alternative: "Other"
property defaultValues : {AbbrNo:0, theName:"", Pinyin:"No", Furigana:"", searchKey:"Other", WellUse:"No", SendMode:"Email", IconID:"", UseReferLicence:"Level", ReferGroupNo:0, ReferPossibleLevel:0, mailAddress:"", FTPServerAddress:"", FTPServerFolder:"", FTPLoginAnonymous:"", FTPLoginUser:"", FTPLoginPassword:"", FTPPassiveSend:"", FTPProxy:"", FTPPortNo:"", SMBAddress:"", SMBFolder:"", SMBLoginUser:"", SMBLoginPassword:"", WebDAVServerAddress:"", WebDAVCollection:"", WebDAVLoginUser:"", WebDAVLoginPassword:"", WebDAVSSL:"", WebDAVProxy:"", WebDAVPortNo:"", BoxID:"", Model:"", FaxPhoneNo:"", FaxCapability:"", FaxV34Off:"", FaxECMOff:"", FaxOversea:"", FaxLine:"", CheckDest:"", theHost:"", PortNo:"", IfaxResolution:"", IfaxSize:"", IfaxCompression:""} -- Default values for the import list

try
	(* Choosing the Multi Functional Peripheral *)
	choose from list mfpDevices
	set theResult to result
	if theResult is false then
		(* Quit upon no choice *)
		return
	else
		set deviceName to theResult
	end if
	
	(* Opening file *)
	set abbrTmpFilePath to (path to desktop as text) & deviceName & "_Abbr.tmp"
	try
		tell application "Finder" to delete abbrTmpFilePath
	end try
	set abbrFilePointer to open for access file abbrTmpFilePath with write permission
	
	(* Generating document header with arbitrary data *)
	set headerLines to {"@Ver032	" & deviceName & "	Integrate	UTF-16LE	2013.6.21 10:4:14	abbr	000ac209552c58a5b6222cf539ab712a255b	", "#Abbreviate	2000	", "AbbrNo	Name	Pinyin	Furigana	SearchKey	WellUse	SendMode	IconID	UseReferLicence	ReferGroupNo	ReferPossibleLevel	MailAddress	FTPServerAddress	FTPServerFolder	FTPLoginAnonymous	FTPLoginUser	FTPLoginPassword	FTPPassiveSend	FTPProxy	FTPPortNo	SMBAddress	SMBFolder	SMBLoginUser	SMBLoginPassword	WebDAVServerAddress	WebDAVCollection	WebDAVLoginUser	WebDAVLoginPassword	WebDAVSSL	WebDAVProxy	WebDAVPortNo	BoxID	Model	FaxPhoneNo	FaxCapability	FaxV34Off	FaxECMOff	FaxOversea	FaxLine	CheckDest	Host	PortNo	IfaxResolution	IfaxSize	IfaxCompression	", "\"alternative\"		\"Yes,No\"		\"Abc,Def,Ghi,Jkl,Mno,Pqrs,Tuv,Wxyz,Other\"	\"Yes,No\"	\"Fax,Email,Ftp,Smb,WebDav,Box,Sip,IP,Ifax\"		\"Group,Level\"						\"Yes,No\"			\"Yes,No\"	\"Yes,No\"										\"Yes,No\"	\"Yes,No\"		\"\"	\"Color,Mono\"		\"Yes,No\"	\"Yes,No\"	\"Yes,No\"	\"Yes,No\"	\"None,Line1,Line2\"	\"Yes,No\"			\"200x100,200x200,400x400,600x600\"	\"A4,B4,A3\"	\"MH,MR,MMR,JpegGray,JpegColor\"	"}
	write (ASCII character 254) & (ASCII character 255) to abbrFilePointer as text -- BOM (U+FEFF) for UTF-16BE
	repeat with headerLine in headerLines
		write headerLine & return & linefeed to abbrFilePointer as Unicode text
	end repeat
	
	(* Get the users list *)
	set shellCommand to "/usr/bin/dscl /LDAPv3/" & ldapHost & " -list /Users"
	do shell script shellCommand
	set theResult to result
	
	(* Iterate through the users list*)
	set AbbrNo to AbbrNo of defaultValues
	set AppleScript's text item delimiters to {return}
	repeat with recordName in every text item of theResult
		(* Exclude users *)
		if recordName is not in excludedUsers then
			set AbbrNo to AbbrNo + 1
			
			(* The mail address*)
			set mailAddress to recordName & "@" & mailDomain
			
			(* Get the users real name to have the first letter of last name *)
			set shellCommand to "/usr/bin/dscl /LDAPv3/" & ldapHost & " -read /Users/" & recordName & " RealName"
			do shell script shellCommand
			set theResult to result
			(* AppleScript's text item delimiters is still set to {return} *)
			set realName to last text item of theResult
			set AppleScript's text item delimiters to {space}
			set lastName to last text item of realName
			set theName to second text item of realName & space & last text item of realName
			set AppleScript's text item delimiters to {return} -- The delimiters previous state
			set firstLetterOfLastName to first item of lastName
			
			(* Choose the appriopriate search key; assign "Other" in case nothing fits *)
			ignoring case and diacriticals
				set searchKey to searchKey of defaultValues
				repeat with currentSearchKey in searchKeys
					if firstLetterOfLastName is in currentSearchKey then
						set searchKey to currentSearchKey
					end if
				end repeat
			end ignoring
			
			(* Preparing the import list *)
			set theLine to (AbbrNo as text) & tab & theName & tab & Pinyin of defaultValues & tab & theName & tab & searchKey & tab & WellUse of defaultValues & tab & SendMode of defaultValues & tab & IconID of defaultValues & tab & UseReferLicence of defaultValues & tab & ReferGroupNo of defaultValues & tab & ReferPossibleLevel of defaultValues & tab & mailAddress & tab & FTPServerAddress of defaultValues & tab & FTPServerFolder of defaultValues & tab & FTPLoginAnonymous of defaultValues & tab & FTPLoginUser of defaultValues & tab & FTPLoginPassword of defaultValues & tab & FTPPassiveSend of defaultValues & tab & FTPProxy of defaultValues & tab & FTPPortNo of defaultValues & tab & SMBAddress of defaultValues & tab & SMBFolder of defaultValues & tab & SMBLoginUser of defaultValues & tab & SMBLoginPassword of defaultValues & tab & WebDAVServerAddress of defaultValues & tab & WebDAVCollection of defaultValues & tab & WebDAVLoginUser of defaultValues & tab & WebDAVLoginPassword of defaultValues & tab & WebDAVSSL of defaultValues & tab & WebDAVProxy of defaultValues & tab & WebDAVPortNo of defaultValues & tab & BoxID of defaultValues & tab & Model of defaultValues & tab & FaxPhoneNo of defaultValues & tab & FaxCapability of defaultValues & tab & FaxV34Off of defaultValues & tab & FaxECMOff of defaultValues & tab & FaxOversea of defaultValues & tab & FaxLine of defaultValues & tab & CheckDest of defaultValues & tab & theHost of defaultValues & tab & PortNo of defaultValues & tab & IfaxResolution of defaultValues & tab & IfaxSize of defaultValues & tab & IfaxCompression of defaultValues
			write theLine & return & linefeed to abbrFilePointer as Unicode text
		end if
	end repeat
	set AppleScript's text item delimiters to {} -- The delimiters initial state
	
	(* Closing document and file  *)
	write "@End	" & return & linefeed to abbrFilePointer as Unicode text
	close access file abbrTmpFilePath
	
	(* Considering UTF-16 AppleScript can only write files with UTF-16BE, so the file must be converted afterwards to UTF-16LE *)
	set abbrFilePath to (path to desktop as text) & deviceName & "_Abbr.txt"
	set shellCommand to "/usr/bin/iconv --from-code=UTF-16BE --to-code=UTF-16LE '" & POSIX path of abbrTmpFilePath & "' > '" & POSIX path of abbrFilePath & "'"
	do shell script shellCommand
	
	(* Cleaning up *)
	try
		tell application "Finder" to delete abbrTmpFilePath
	end try
	
	(* Finally open the Abbr file *)
	tell application "Finder" to open abbrFilePath
on error m number n
	(* Trying to close opened file and passing the error through *)
	try
		close access file abbrTmpFilePath
	end try
	error m number n
end try

(* End of Script *)
