//verify if the gallery needs a password
function check_secure(component) {
	//Only check if secure values is defined
	if (secure_values && component) {
		var val = component.options[component.selectedIndex].value;
		var i = 0;
		for (i = 0; i < secure_values.length; i++) {
			if (secure_values[i] == val) {
				//Found the selected value in the list of secure values
				// Go ahead and show the password box
				$("password_label").style.display = "block";
				$("password").style.display = "block";
				return;
			}
		}
	}
	//If you haven't found it, hide the password section
	$("password_label").style.display = "none";
	$("password").style.display = "none";
}