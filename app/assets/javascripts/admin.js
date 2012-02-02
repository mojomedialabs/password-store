//= require jquery
//= require jquery_ujs
//= require_self

var lastTextArea;

$(function(){
  // Close flash[:alert] messages when clicked
  $(".click-to-close").click(function() {
		$(this).fadeTo(400, 0, function () {
			$(this).slideUp(400);
		});
		return false;
	});

  // Reset focus to search forms if they have stuff in them
	if ($("#search").length) {
		if ($("#search").val().length > 0) {
			$("#search").focus();
		}
	}

  // AJAX history
	if (history && history.pushState) {
		$("#index-search").submit(function() {
			$.get(this.action, $(this).serialize(), null, "script");

			history.pushState(null, document.title, this.action + "?" + $(this).serialize());

			return false;
		});

		$("th a, .pagination a").live("click", function() {
			$.getScript(this.href);

			history.pushState(null, "", this.href);

			return false;
		});

		$(window).bind("popstate", function() {
			$.getScript(location.href);
		});
	}

  // Check all checkbox for index pages
	$(".check-all").click(function() {
		$(this).parent().parent().parent().parent().find("input[type='checkbox']").attr("checked", $(this).is(":checked"));
	});

  // Only allow multiple items to be edited/removed if at least one is selected
	$("input:checkbox").click(function() {
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
	$("#toggle-debug").click(function() {
		$("#debug-info").slideToggle();

		$(".toggle-debug-text").toggle();
	});

  // Fill out user email confirmation so it doesn't have to be done manually every time
  $("#user_email_address_confirmation").val($("#user_email_address").val());

  // Empty user email confirmation if email changes
  $("#user_email_address").keyup(function() {
    $("#user_email_address_confirmation").val("");
    $("#user_email_address_confrimation").attr("placeholder", $("#user_email_address").val());
  });

  // Empty user password confirmation if password changess
  $("#user_password").keyup(function() {
    $("#user_password_confirmation").val("");
  });

  // Get picture selector
  $("#picture-selector-button").click(function(event) {
    event.preventDefault();

    if ($("#picture-selector-container").length === 0) {
      var jqxhr = $.get("/admin/pictures/selector", null, function(data, textStatus, jqXHR) {
        $(".content").append(data);
    	}, "html");
    }
  });

  lastTextArea = $("textarea").first();

  $("textarea").focus(function() {
    lastTextArea = this;
  });

  // Remove assessment, section, question, or answer
  $(".remove img").live("click", function() {
    console.log($(this).parent().find(".remove-field"));

    $(this).parent().find(".remove-field").val("true");

    $(this).parent().parent().addClass("deleted-field");

    $(this).parent().parent().slideUp();

    updateDisplayOrders();
  });

  // Go through all sections, questions, and answers and update their display order
  function updateDisplayOrders() {
    $(".section").not(".deleted-field").find("> .display-order > .display-order-field").not(".deleted-field").each(function(index, value) {
      $(this).val(index);
    });

    $(".section").each(function() {
      var fields = $(this).find(".question").not(".deleted-field").find("> .display-order > .display-order-field");

      $.each(fields, function(index, value) {
        $(this).val(index);
      });
    });

    $(".question").each(function() {
      var fields = $(this).find(".answer").not(".deleted-field").find("> .display-order > .display-order-field");

      $.each(fields, function(index, value) {
        $(this).val(index);
      });
    });
  }

  // Do this every time to start off with for good measure
  updateDisplayOrders();

  // Move section, question, or answer up, then update all display orders
  $(".display-order .increase-display-order").live("click", function() {
    var element = $(this).parent().parent();

    var elementClass = element.attr("class");

    var elementHiddenField = element.next();

    var previousElement = element.prev().prev();

    if (previousElement.hasClass(elementClass)) {
      element.insertBefore(previousElement);
      elementHiddenField.insertAfter(element);
    }

    updateDisplayOrders();
  });

  // Move section, question, or answer down, then update all display orders
  $(".display-order .decrease-display-order").live("click", function() {
    var element = $(this).parent().parent();

    var elementClass = element.attr("class");

    var elementHiddenField = element.next();

    var nextElement = element.next().next();

    if (nextElement.hasClass(elementClass)) {
      element.insertAfter(nextElement.next());
      elementHiddenField.insertAfter(element);
    }

    updateDisplayOrders();
  });

  // When submitting assessment, double check all the result upper and lower ends
  $("#assessment-form").submit(function(event) {
    $(".result").each(function() {
        if (parseInt($(this).find(".result-bottom input[type='text']").val(), 10) > parseInt($(this).find(".result-top input[type='text']").val(), 10)) {
          //may change this to inserting a div with the error message
          alert("Result upper end must be above lower end.");

          $("html, body").animate({ scrollTop: $(this).offset().top - 30 }, 250);

          $(this).focus();

          event.preventDefault();

          return false;
        }
    });

    $(".assessment > fieldset > .result").each(function() {

    });
  });
});

// Add section, question, or answer, then update all display orders
function addFields(link, association, content) {
  var newID = new Date().getTime();
  var regExp = new RegExp("new_" + association, "g");

  $(link).parent().append(content.replace(regExp, newID));

  var newLink = $(link).parent().children().last();

  $(link).before(newLink);

  updateDisplayOrders();
}
