(function() {
  document.addEventListener('trix-initialize', function(e) {
    trix = e.target;
    toolBar = trix.toolbarElement;

    // Creation of the button
    button = document.createElement("button");
    button.setAttribute("type", "button");
    button.setAttribute("class", "formula");
    button.setAttribute("data-trix-attribute", "insertFormula");
    button.setAttribute("title", "Insérer une formule");
    button.innerText = "Insérer une formule";

    // Attachment of the button to the toolBar
    formulaButton = toolBar.querySelector('.button_group.text_tools').appendChild(button);

    // Creating the dialog
    dialog = document.createElement("div");
    dialog.setAttribute("class", "dialog math-dialog");
    dialog.setAttribute("data-trix-dialog", "insertFormula");
    dialog.innerHTML =
      '<div class="row"><div class="column m6"><p>Saisir une formule</p><textarea id="MathInput" style="width: 100%;"></textarea></div><div class="column m6"><p>Prévisualisation</p><div id="MathPreview" data-tex-input=""></div></div></div><div class="input boolean"><input id="inline_or_display" type="checkbox" class="boolean" value="0"></input><label for="inline_or_display" class="boolean">Insérer sur une nouvelle ligne?</label></div><button class="btn btn-insert-math">Insérer</button>';

    // Attaching the dialog
    toolBar.querySelector('.dialogs').appendChild(dialog);

    // Typeset math
    var typeset_math = function() {
      if (document.getElementById('inline_or_display').checked) {
        var math_input = '$$' + $('#MathInput').val() + '$$';
      } else {
        var math_input = '$' + $('#MathInput').val() + '$';
      }
      var math_to_output = $('#MathPreview').data('tex-input');
      if (math_input === math_to_output) return;
      $('#MathPreview').html(math_input);
      $('#MathPreview').data('tex-input', math_input);
      MathJax.Hub.Queue(["Typeset",MathJax.Hub,"MathPreview"]);
    };

    $('#MathInput').on('keyup', function() {
      typeset_math();
    });

    $('#inline_or_display').on('change', function() {
      typeset_math();
    });

    // Insert math
    $('button.btn-insert-math').on('click', function(event) {
      event.preventDefault();
      var element = document.querySelector('trix-editor');
      var math_to_insert = $('#MathPreview').data('tex-input');
      element.editor.insertString(math_to_insert);
      element.focus();
    });
  });
}).call(this);
