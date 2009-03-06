function select_image(image_path) {
  var target_window = window.parent;
  var image_dialog_editor;
  var image_source_form;

  if (!target_window)
      return;

  image_dialog_editor = target_window.image_dialog_window;
  if (!image_dialog_editor)
      return;

  image_source_form = image_dialog_editor.document.getElementById('src');
  if (!image_source_form)
      return;

  image_source_form.value = image_path;
  try {
      image_source_form.onchange();
  } catch (e) {
  }

  setTimeout(function () {
    var editor = target_window.tinymce.EditorManager.activeEditor;
    editor.windowManager.close(window);
  },
  0);
}
