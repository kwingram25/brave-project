$(document).on("ajax:beforeSend", function() {
  $('#app').addClass('loading');
});