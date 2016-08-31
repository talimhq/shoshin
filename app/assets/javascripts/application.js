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
//= require jquery-ui
//= require turbolinks
//= require jquery.ui.touch-punch
//= require cocoon
//= require trix
//= require select2.full
//= require i18n/fr
//= require_tree .

document.addEventListener('turbolinks:load', function () {
  var state_options = $('#school_state').html();
  $('#school_country').on('change', function() {
    if ($(this).val() === 'FR') {
      $('#school_state').html(state_options);
      $('option[value="99"]').remove();
      $('#school_state').change();
    } else {
      $('#school_state').html('<option></option><option value="99">Étranger</option>').change();
    }
  });

  $('main').animate({opacity: '1'});

  $('input').each(function() {
    animateLabels(this);
  });

  $('select:not(.no-select)').select2({language: 'fr'});

  $(document).on('cocoon:after-insert', function(event, insertedItem) {
    $(insertedItem).find('input').each(function() {
      animateLabels(this);
    });

    $(insertedItem).find('select').each(function() {
      $(this).select2({language: 'fr'});
    });
  });

  $(document).on('click', function(event) {
    if(!$(event.target).closest('#drawer').length && !$(event.target).is('#drawer') &&
      !$(event.target).closest('.menu-toggler').length && !$(event.target).is('.menu-toggler')) {
      if($('#drawer').hasClass('visible')) {
          $('#drawer').removeClass('visible');
      }
    }
  });

  $('.menu-toggler').on('click', function() {
    toggleDrawer();
  });

  $('.toast-container').hide().slideToggle('slow').delay(5000).slideToggle('slow');

  $('.tab-content').first().addClass('active');
  $('ul.tabs > li.tab').first().addClass('active');
  $('ul.tabs:not(.vertical) > li.tab a').on('click', function(e) {
    e.preventDefault();
    $(this).closest('.tabs-area').next().find('.tab-content').removeClass('active');
    $(this).closest('ul.tabs').find('li.tab').removeClass('active');
    $(this).closest('li.tab').addClass('active');
    $($(this).attr('href')).addClass('active');
  });

  MathJax.Hub.Queue(["Typeset",MathJax.Hub]);
});

document.addEventListener('turbolinks:request-start', function () {
  $('main').animate({opacity: '0'});
});

function animateLabels(input) {
  if ($(input).val()) {
    $(input).addClass('used');
  } else {
    $(input).removeClass('used');
  }
  $(input).on('blur change', function() {
    if ($(input).val()) {
      $(input).addClass('used');
    } else {
      $(input).removeClass('used');
    }
  });
}

function toggleDrawer() {
  $('#drawer').toggleClass('visible');
}
