tell application "iTerm2"
	create window with default profile

	tell current session of current window
		write text "cd " & quoted form of (system attribute "PWD")

		split vertically with default profile

		tell second session of current tab
			write text "cd " & quoted form of (system attribute "PWD")

			split horizontally with default profile

			tell third session of current tab
				write text "cd " & quoted form of (system attribute "PWD")
			end tell
		end tell
	end tell
end tell