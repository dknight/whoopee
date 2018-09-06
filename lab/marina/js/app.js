var ICON_ANIMATION_TIME = 800;
var SCROLL_TO_TIME = 200;

jQuery(function ($) {
  
  $body = $('body');
  $body.imagesLoaded( function() {
    $body.addClass('loaded');
    $('#loader').fadeOut("fast").remove();
  });
  
  $('#burger-button').on('click', function (e) {
    e.preventDefault();
    $('#main-navigation').toggleClass('active');
  });
  
  $('#main-navigation a, #logo').on('click', function (e) {
    $('#main-navigation').removeClass('active');
  });
  
  $('.icon-container').on('mouseover', function () {
    var $icon = $(this).find('.fa');
    $icon.addClass('play');
    
    setTimeout(function () {
      $icon.removeClass('play');
    }, ICON_ANIMATION_TIME + 10);
  });
  
  $('#main-navigation a:not(#lang-switch)').on('click', function (e) {
    var hash = $(this).attr('href');
    $(window).scrollTo(hash, SCROLL_TO_TIME);
  });
  
  $('#logo').on('click', function (e) {
    $(window).scrollTo(0, SCROLL_TO_TIME);
  });
  
  $('#lang-switch').on('click', function (e) {
    e.preventDefault();
    alert('Dummy function');
  });
  
  $('.gallery a').featherlightGallery();
  
  $.fn.waypoint.defaults = {
    context: window,
    continuous: true,
    enabled: true,
    horizontal: false,
    offset: '80%',
    triggerOnce: true
  };
  
  $('section').waypoint(function (direction) {
    $(this).toggleClass('in');
  });
  
  // Check for crappy Android
  if(navigator.userAgent.toLowerCase().indexOf('android') > -1) { // Is Android.
      $(document.body).addClass('android');
  }

});