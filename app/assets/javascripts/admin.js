//= require jquery
//= require jquery_ujs
//= require_self

var lastTextArea;

$(function() {
	// Close flash[:alert] messages when clicked
	//$(".click-to-close").click(function(event) {
	$(".click-to-close").on("click", function(event) {
		event.preventDefault();

		$(this).fadeTo(400, 0, function () {
			$(this).slideUp(400);
		});
	});

	// Reset focus to search forms if they have stuff in them
	if ($("#search").length) {
		if ($("#search").val().length > 0) {
			$("#search").focus();
		}
	}

	// AJAX history
	if (history && history.pushState) {
		//$("#index-search").submit(function() {
		$("#index-search").on("click", function(event) {
			event.preventDefault();

			$.get(this.action, $(this).serialize(), null, "script");

			history.pushState(null, document.title, this.action + "?" + $(this).serialize());
		});

		//$("th a, .pagination a").live("click", function() {
		$(document).on("click", "th a, .pagination a", function(event) {
			event.preventDefault();

			$.getScript(this.href);

			history.pushState(null, "", this.href);
		});

		//$(window).bind("popstate", function() {
		$(window).on("popstate", function(event) {
			$.getScript(location.href);
		});
	}

	// Check all checkbox for index pages
	//$(".check-all").click(function() {
	$(".check-all").on("click", function(event) {
		$(this).parent().parent().parent().parent().find("input[type='checkbox']").attr("checked", $(this).is(":checked"));
	});

	// Only allow multiple items to be edited/removed if at least one is selected
	//$("input:checkbox").click(function() {
	$("input:checkbox").on("click", function(event) {
		var buttonsChecked = $("input:checkbox:checked");

		if (buttonsChecked.length) {
			$("#edit-selected-button").removeAttr("disabled");
			$("#delete-selected-button").removeAttr("disabled");
		} else {
			$("#edit-selected-button").attr("disabled", "disabled");
			$("#delete-selected-button").attr("disabled", "disabled");
		}
	});

	// Toggle debug view when showing items
	//$("#toggle-debug").click(function() {
	$("#toggle-debug").on("click", function(event) {
		$("#debug-info").slideToggle();

		$(".toggle-debug-text").toggle();
	});

	// Fill out user email confirmation so it doesn't have to be done manually every time
	$("#user_email_address_confirmation").val($("#user_email_address").val());

	// Empty user email confirmation if email changes
	//$("#user_email_address").keyup(function() {
	$("#user_email_address").on("keyup", function(event) {
		$("#user_email_address_confirmation").val("");
		$("#user_email_address_confrimation").attr("placeholder", $("#user_email_address").val());
	});

	// Fill out user password confirmation so it doesn't have to be done manually every time
	$("#user_password_confirmation").val($("#user_password").val());

	// Empty user password confirmation if password changess
	//$("#user_password").keyup(function() {
	$("#user_password").on("keyup", function(event) {
		$("#user_password_confirmation").val("");
	});

	// Show/Hide Password
	$(".show-hide-password").on("click", function(event) {

	});
});
