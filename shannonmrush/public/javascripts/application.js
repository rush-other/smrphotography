var selected = null;

//Swap out images on hover over
function img_hover(img, src, test_selected) {
	if (test_selected && selected == src) {
		//This is the selected page, leave it selected
	} else {
		//Otherwise, go ahead and swap out to the standard image
		img.src = "/images/" + src;
	}
}

//Mark the selected page
function set_page(page) {
	selected = page;
}

//Check for the keypress of "Enter" and submit subscription
function enter_subscription(evt) {
	if (window.event) evt = window.event;
	if (evt.keyCode == 13) {
		//Keypress was "Enter", submit 
		// and short-circuit the keypress event
		submit_subscription();
		return false;
	} else {
		//Otherwise, return true, do not short-circuit
		return true;
	}
}
//Submit the subscription
function submit_subscription() {
	var email = $('subscribe').value;
	new Ajax.Updater('subscribe_message', '/gallery/subscribe?email=' + email, {onComplete:clear_subscribe_text});
}
function clear_subscribe_text() {
	$('subscribe').value = "";
}
