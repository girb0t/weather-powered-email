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
    handleFormSubmit();
  })

  $('#email-input').blur(function(event) {
    validateEmail(event.target.value);
  })

  function handleFormSubmit() {
    var emailVal = $('#email-input').val();
    var cityVal= $('#city-select').val();
    if (validateEmail(emailVal) && validateCity(cityVal)) {
      disableSubmitBtn(); // prevent double-clicking
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
  }

  function onSubmitSuccess(response) {
    showAlert('success', response.message);
    resetForm();
  }

  function onSubmitError(response) {
    showAlert('danger', response.responseJSON.message)
    enableSubmitBtn()
  }

  function validateEmail(email) {
    var regex = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    if (regex.test(email)) {
      showValidEmailMsg()
      return true;
    } else {
      showInvalidEmailMsg();
      return false;
    }
  }

  function validateCity(value) {
    if (value === 'EMPTY') {
      showInvalidLocationMsg()
      return false;
    } else {
      return true;
    }
  }

  function showInvalidEmailMsg() {
    clearEmailFormControlMsg();
    var $errorMsg = $('.form-group.email .form-control-msg.error');
    $errorMsg.show().text('Invalid format.');
  }

  function showValidEmailMsg() {
    clearEmailFormControlMsg();
    var $success_msg = $('.form-group.email .form-control-msg.success');
    $success_msg.show().text('Good email.');
  }

  function showInvalidLocationMsg() {
    $errorMsg = $('.form-group.location .form-control-msg.error');
    $errorMsg.show().text('Please choose a location.');
  }

  function resetForm() {
    clearFormInput();
    clearAllFormControlMsg();
    enableSubmitBtn();
  }

  function clearFormInput() {
    $('#email-input').val('');
    $('#city-select').val('EMPTY');
  }

  function clearAllFormControlMsg() {
    clearEmailFormControlMsg();
    clearLocationFormControlMsg();
  }

  function clearEmailFormControlMsg() {
    $('.form-group.email .form-control-msg.error').hide();
    $('.form-group.email .form-control-msg.success').hide();
  }

  function clearLocationFormControlMsg() {
    $('.form-group.location .form-control-msg.error').hide();
  }

  function disableSubmitBtn() {
    $('#new-user-form button').prop('disabled', true);
  }

  function enableSubmitBtn() {
    $('#new-user-form button').prop('disabled', false);
  }

  function showAlert(type, message) {
    type = type || 'info' // possible types are 'info', 'success', 'warning', and 'danger'

    var html =  `<div class="alert alert-${type} alert-dismissable fade in">`
    html +=       '<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>'
    html +=       message
    html +=     '</div>'

    $('#alert-container').html(html);
  }
});
