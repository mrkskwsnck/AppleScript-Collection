(* Show and optionally cancel print jobs from a given queue *)

property printer_queue_name : "Canon_iP100_series"

try
	set one_liner to "/usr/bin/lpstat -o " & printer_queue_name
	do shell script one_liner
	set stdout to result
	
	set AppleScript's text item delimiters to return
	set print_jobs to text items of stdout
	set AppleScript's text item delimiters to {}
	
	choose from list print_jobs with title "List of pending print jobs" OK button name "Cancel" cancel button name "Exit" with multiple selections allowed
	set destiny to result
	
	if destiny � false then
		repeat with print_job in destiny
			set AppleScript's text item delimiters to space
			set queue_job_id to first text item of print_job
			set AppleScript's text item delimiters to "-"
			set job_id to second text item of queue_job_id
			set AppleScript's text item delimiters to {}
			
			set one_liner to "/usr/bin/lprm -P " & printer_queue_name & space & job_id
			do shell script one_liner
		end repeat
		
		display dialog "The chosen print jobs have been cancelled." with title "Printer queue" buttons {"OK"} default button "OK"
	end if
on error m number n
	if n = -50 then
		display dialog "The printer's job queue ist empty!" with title "Printer queue" buttons {"OK"} default button "OK"
	else
		error m number n
	end if
end try
