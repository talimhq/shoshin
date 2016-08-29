(function() {
  document.addEventListener('turbolinks:load', function(e) {
    $('.select-all').on('click', function(e) {
      e.preventDefault();
      $(this).closest('.classroom_students_checkboxes').find('input:checkbox').each(function() {
        $(this).prop('checked', true);
      });
    });

    $('.unselect-all').on('click', function(e) {
      e.preventDefault();
      $(this).closest('.classroom_students_checkboxes').find('input:checkbox').each(function() {
        $(this).prop('checked', false);
      });
    });
  });
}).call(this);
