var scrollToBottom = function() {
  var chat_messages = document.getElementsByClassName('chat-messages')[0];
  if (chat_messages) {
    chat_messages.scrollTop = chat_messages.scrollHeight;
  }
}

var parseMessagesAuthor = function() {
  $('.message').each(function(index) {
    if ($(this).data('user-type') != $(this).prev().data('user-type') & $(this).data('user-id') != $(this).prev().data('user-id')) {
      $(this).addClass('first');
    }
  });
}

document.addEventListener('turbolinks:load', function() {
  parseMessagesAuthor();
  scrollToBottom();
  $('#new_group_notification').on('keypress', function(e) {
    if (e && e.keyCode == 13) {
      e.preventDefault();
      $(this).submit();
    }
  });
});
