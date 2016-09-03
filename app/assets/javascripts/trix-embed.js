(function() {
  document.addEventListener('trix-initialize', function(e) {
    trix = e.target;
    toolBar = trix.toolbarElement;

    // Creation of the button
    button = document.createElement("button");
    button.setAttribute("type", "button");
    button.setAttribute("class", "embed");
    button.setAttribute("data-trix-attribute", "insertEmbed");
    button.setAttribute("title", "Insérer une iframe");
    button.innerText = "Insérer une iframe";

    // Attachment of the button to the toolBar
    formulaButton = toolBar.querySelector('.button_group.text_tools').appendChild(button);

    // Creating the dialog
    dialog = document.createElement("div");
    dialog.setAttribute("class", "dialog embed-dialog");
    dialog.setAttribute("data-trix-dialog", "insertEmbed");
    dialog.innerHTML = '<div class="row"><div class="column xs12"><p>Coller le code iframe</p><textarea id="EmbeddedCode" style="width: 100%;"></textarea><button class="btn btn-insert-embed">Insérer</a></div></div>'
    // Attaching the dialog
    toolBar.querySelector('.dialogs').appendChild(dialog);

    // Insert math
    $('button.btn-insert-embed').on('click', function(event) {
      event.preventDefault();
      var element = document.querySelector('trix-editor');
      var embedded = $('#EmbeddedCode').val();
      element.editor.insertAttachment(new Trix.Attachment({content: embedded}));
      element.focus();
    });
  });
}).call(this);
