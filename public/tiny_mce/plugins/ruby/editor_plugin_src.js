/**
 * @author Kouhei Sutou
 * @copyright Copyright 2009, ClearCode Inc. All rights reserved.
 * @license GPLv3 or AGPLv3
 */

(function() {
	tinymce.create('tinymce.plugins.RubyPlugin', {
		init : function(ed, url) {
			if (ed.settings.language) {
				var lang_url;
				lang_url = url + "/langs/" + ed.settings.language + ".js";
				tinymce.ScriptLoader.load(lang_url);
			}

			// Register commands
			ed.addCommand('mceRuby', function() {
				ed.windowManager.open({
					file: url + '/ruby.htm',
					width: 350 + parseInt(ed.getLang('ruby.delta_width', 0)),
					height: 250 + parseInt(ed.getLang('ruby.delta_height', 0)),
					inline: true
				}, {
					plugin_url: url
				});
			});

			// Register buttons
			ed.addButton('ruby', {title: 'ruby.desc', cmd: 'mceRuby'});

			ed.onPreInit.add(function () {
				ed.serializer.addRules("ruby,rb,rp,rt");
			});

			ed.onNodeChange.add(function(ed, cm, n, co) {
				n = ed.dom.getParent(n, 'RUBY');

				cm.setDisabled('ruby', co);
				cm.setActive('ruby', false);

				// Activate all
				if (n) {
					do {
						cm.setDisabled(n.nodeName.toLowerCase(), false);
						cm.setActive(n.nodeName.toLowerCase(), true);
					} while (n = n.parentNode);
				}
			});
		},

		getInfo : function() {
			return {
				longname: 'Ruby Plugin',
				author: 'Kouhei Sutou at ClearCode Inc.',
				authorurl: 'http://www.clear-code.com/',
				version: "0.1"
			};
		}
	});

	// Register plugin
	tinymce.PluginManager.add('ruby', tinymce.plugins.RubyPlugin);
})();

/*
 * Local Variables:
 * indent-tabs-mode: t
 * tab-width: 4
 * End:
 */
