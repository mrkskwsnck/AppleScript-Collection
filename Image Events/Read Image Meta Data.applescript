(* Related URI:	http://www.macosxautomation.com/applescript/imageevents/09.html *)

set this_file to choose file without invisibles
try
	set tag_text to ""
	
	tell application "Image Events"
		-- start the Image Events application
		launch
		-- open the image file
		set this_image to open this_file
		-- extract the metadata values
		tell this_image
			repeat with current_tag in metadata tags
				try
					set the tag_name to the name of current_tag
					set the tag_value to the value of current_tag
					
					set the tag_text to tag_text & tag_name & ": " & tag_value & return
				on error
					if the tag_name is "profile" then
						set the tag_text to the tag_text & tag_name & ": " & name of tag_value & return
					end if
				end try
			end repeat
			
			(* Orientation *)
			set image_dimensions to dimensions
			set image_width to item 1 of image_dimensions
			set image_height to item 2 of image_dimensions
			set image_orientation to missing value
			
			if image_width > image_height then -- Landscape orientation
				set image_orientation to "Landscape"
			else if image_height > image_width then -- Portrait orientation
				set image_orientation to "Portrait"
			else
				set image_orientation to "Balanced"
			end if
			
			set tag_text to tag_text & "orientation: " & image_orientation & return
			
			(* Other data *)
			set tag_text to tag_text & "bitDepth: " & bit depth & return
			set tag_text to tag_text & "classicLocationPath: " & path of location & return
			set tag_text to tag_text & "name: " & name
		end tell
		-- purge the open image data
		close this_image
	end tell
	
	display dialog tag_text with title "Image Meta Data" buttons {"OK"} default button 1
on error error_message
	display alert error_message as critical buttons {"Cancel"} cancel button 1
end try
