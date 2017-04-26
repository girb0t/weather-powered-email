// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require turbolinks
//= require_tree .

$(function() {
  $('#new-user-form').submit(function(event) {
    event.preventDefault();
    var emailVal = $('#email-input').val();
    var cityVal= $('#city-select').val();
    if (validateEmail(emailVal) && validateCity(cityVal)) {
      data = {
        email: emailVal,
        city_id: cityVal
      }

      $.ajax({
        type: "POST",
        url: '/users',
        data: data,
        success: onSubmitSuccess,
        error: onSubmitError,
        dataType: 'json'
      });
    }
  })

  function onSubmitSuccess(response) {
    alert('success!')
  }

  function onSubmitError(response) {
    alert('ERROR')
  }

  function validateEmail(email) {
    return true;
  }

  function validateCity(value) {
    return true;
  }
});
