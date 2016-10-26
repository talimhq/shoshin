if ($('meta[name="current-account"]').length > 0) {
  App.groups = App.cable.subscriptions.create("GroupsChannel", {
    connected: function() {
      // Called when the subscription is ready for use on the server
    },

    disconnected: function() {
      // Called when the subscription has been terminated by the server
    },

    received: function(data) {
      $('[data-behaviour="chat-messages"][data-group-id="' + data.group_id + '"]').append(data.message);
      parseMessagesAuthor();
      MathJax.Hub.Queue(["Typeset",MathJax.Hub]);
      scrollToBottom();
    }
  });
}
