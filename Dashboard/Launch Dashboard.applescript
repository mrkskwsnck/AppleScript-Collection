(* Related links:
¥ http://hints.macworld.com/article.php?story=20050809161107602
¥ http://www.fischer-bayern.de/phpBB2/viewtopic.php?t=1967
Type: Stay Open Application *)

-- Function Key Values
(*
F1  - 122 
F2  - 120 
F3  - 99 
F4  - 118 
F5  - 96 
F6  - 97 
F7  - 98 
F8  - 100 
F9  - 101 
F10 - 109 
F11 - 103 
F12 - 111 
F13 - 105 
F14 - 107 
F15 - 113
*)

-- Configure how long do we wait until Dashboard is closed/deactivated
property intWaitDelay : 2 -- Seconds
-- Configure which key we press for Dashboard to be triggered.
property intFunctionKeyValue : 111 -- F12

-- Application's properties
property dateGoal : ""

on run
	tell application "System Events" to key code intFunctionKeyValue
	-- Add our Wait Delay to the current date
	set dateGoal to (current date) + intWaitDelay
end run

on idle
	if ((current date) is greater than or equal to dateGoal) then
		tell application "System Events" to key code intFunctionKeyValue
		quit -- Exit
	end if
	return intWaitDelay
end idle

(* EoF *)