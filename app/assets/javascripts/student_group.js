(function() {
  document.addEventListener('turbolinks:load', function() {
    $('#group_level_id').on('change', function() {
      var level_id = $(this).val();
      $.ajax({
        method: 'GET',
        url: '/professeur/niveaux/' + level_id + '/eleves'
      });
    });
  });
}).call(this);
