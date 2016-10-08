(function() {
  function toggleChildren(target) {
    var children = target.find('.children');
    if (target.hasClass('selected')) {
      children.css('margin-top', '0');
    } else {
      children.css('margin-top', - children.height());
    }
  }

  document.addEventListener('turbolinks:load', function() {
    $('.accordion-area .parent').each(function() {
      toggleChildren($(this));
    });

    $('.accordion-area h4').on('click', function(e) {
      var target = $(this).closest('.parent');
      target.siblings().removeClass('selected');
      target.toggleClass('selected');
      $('.accordion-area .parent').each(function() {
        toggleChildren($(this));
      });
    });
  });
}).call(this);
