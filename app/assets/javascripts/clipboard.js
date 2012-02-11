$(function() {
	ZeroClipboard.setMoviePath("/assets/ZeroClipboard.swf");

	var clip = new ZeroClipboard.Client();
	clip.setHandCursor(true);

	$(".copy-to-clipboard").mouseover(function() {
		clip.setText(this.innerHTML);

		if (clip.div) {
			clip.receiveEvent("mouseout", null);
			clip.reposition(this);
		} else {
			clip.glue(this);
		}

		clip.receiveEvent("mouseover", null);
	});
});