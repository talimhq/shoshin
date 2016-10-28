var scrollToBottom = function() {
  var chat_messages = document.getElementsByClassName('chat-messages')[0];
  if (chat_messages) {
    chat_messages.scrollTop = chat_messages.scrollHeight;
  }
}

var parseMessagesAuthor = function() {
  $('.message').each(function(index) {
    if ($(this).data('user-type') !== $(this).prev().data('user-type') & $(this).data('user-id') !== $(this).prev().data('user-id')) {
      $(this).addClass('first');
    }
  });
}

var triggerForRemove = function() {
  $('.message_destroy').off('click')
                       .on('click', function(e) {
    e.preventDefault();
    var message = $(this).closest('.message');
    message.remove();
    parseMessagesAuthor();
    scrollToBottom();
    $.ajax({
      method: 'DELETE',
      url: message.data('message-url')
    })
  });
}

document.addEventListener('turbolinks:load', function() {
  parseMessagesAuthor();
  scrollToBottom();
  triggerForRemove();
  $('#new_group_notification').on('keypress', function(e) {
    if (e && e.keyCode === 13) {
      e.preventDefault();
      $(this).submit();
    }
  });
});
