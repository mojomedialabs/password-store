#= require jquery
#= require jquery-ui
#= require jquery_ujs
#= require_self

$ ->
  $(".click-to-close").click ->
    $(this).fadeTo 400, 0, ->
      $(this).slideUp 400
  $.fn.fadingLinks = (color, duration = 500) ->
    @each ->
      original = $(this).css("color")
      $(this).mouseover ->
        $(this).stop().animate color: color, duration
      $(this).mouseout ->
        $(this).stop().animate color: original, duration
  $("#user_email_address_confirmation").val $("#user_email_address").val()
  $("#user_email_address").keyup ->
    $("#user_email_address_confirmation").val ""
    $("#user_email_address_confrimation").attr "placeholder", $("#user_email_address").val()
  $("#user_password").keyup ->
    $("#user_password_confirmation").val ""