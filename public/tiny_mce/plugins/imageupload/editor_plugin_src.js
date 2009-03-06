/**
 * @author Kouhei Sutou
 * @copyright Copyright 2009, ClearCode Inc. All rights reserved.
 * @license GPLv3 or AGPLv3
 */

(function() {
	var ImageUpload = {
		editor: null,
		url: null,
		file_browser_callback: function(id, value, type, _window) {
			var _this = ImageUpload;
			var settings = {};

			window.image_dialog_window = _window;
			_this.editor.windowManager.open({
				name: 'imageupload',
				url: _this.editor.settings.image_upload_url,
				scrollbars: 'yes',
				width: 500,
				height: 400,
				inline: true
			},
			settings);

			return true;
		}
	};

	tinymce.create('tinymce.plugins.ImageUploadPlugin', {
		init : function(editor, url) {
			ImageUpload.editor = editor;
			ImageUpload.url = url;
			editor.settings.file_browser_callback = ImageUpload.file_browser_callback;
		},

		getInfo : function() {
			return {
				longname: 'ImageUpload Plugin',
				author: 'Kouhei Sutou at ClearCode Inc.',
				authorurl: 'http://www.clear-code.com/',
				version: "0.1"
			};
		}
	});

	// Register plugin
	tinymce.PluginManager.add('imageupload', tinymce.plugins.ImageUploadPlugin);
})();

/*
 * Local Variables:
 * indent-tabs-mode: t
 * tab-width: 4
 * End:
 */
