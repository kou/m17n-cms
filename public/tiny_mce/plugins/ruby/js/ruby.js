/**
 * @author Kouhei Sutou
 * @copyright Copyright 2009, ClearCode Inc. All rights reserved.
 * @license AGPLv3
 */

(function () {
	var editor, base_url, url;

	editor = tinymce.EditorManager.activeEditor;
	base_url = tinyMCEPopup.getWindowArg('plugin_url') || tinyMCEPopup.getWindowArg('theme_url');
	url = base_url + "/../xhtmlxtras/langs/" + editor.settings.language + "_dlg" + ".js";
	if (!tinymce.ScriptLoader.isDone(url)) {
			document.write('<script type="text/javascript" src="' + tinymce._addVer(url) + '"></script>');
			tinymce.ScriptLoader.markDone(url);
	}
})();

function getFormValue(name)
{
		var element = document.forms[0].elements[name];

		if (element)
				return element.value;
		else
				return null;
}

function init() {
	SXE.initElementDialog('ruby');
	if (SXE.currentAction == "update") {
		var element = SXE.inst.dom.getParent(SXE.focusElement, "RUBY");

		if (element) {
			var rt = null;
			tinymce.each(element.childNodes, function (node) {
				if (node.nodeName.toUpperCase() == "RT") {
					if (node.textContent)
						rt = node.textContent;
					else
						rt = node.innerText;
					return;
				}
			});
			setFormValue('ruby', rt);
		}

		SXE.showRemoveButton();
	}
}

function setAllCommonAttribs(element) {
	var dom = SXE.inst.dom;
	var parentheses = [];
	var text = null;
	var base = null;
	var bases = [];

	tinymce.each(element.childNodes, function (node) {
		if (node.nodeName.toUpperCase() == "RB") {
			base = node;
		} else if (node.nodeName.toUpperCase() == "RT") {
			text = node;
		} else if (node.nodeName.toUpperCase() == "RP") {
			parentheses = parentheses.concat([node]);
		} else {
			bases = bases.concat([node]);
		}
	});

	if (!base) {
		base = dom.create("rb", {});
		tinymce.each(bases, function (node) {
			base.appendChild(node);
		});
		element.appendChild(base);
	}

	tinymce.each(parentheses, function (node) {
		element.removeChild(node);
	});

	if (text) {
		var new_text;

		new_text = dom.create("rt", {}, getFormValue("ruby"));
		element.replaceChild(new_text, text);
		text = new_text;
	} else {
		text = dom.create("rt", {}, getFormValue("ruby"));
		element.appendChild(text);
	}

	element.insertBefore(dom.create("rp", {}, "("), text);
	dom.insertAfter(dom.create("rp", {}, ")"), text);
}

function insertRuby() {
	SXE.insertElement('ruby');
	tinyMCEPopup.close();
}

function removeRuby() {
	var ruby;
	var base = null;
	var bases = [];
	var TEXT_NODE = 3;

	ruby = SXE.inst.dom.getParent(SXE.focusElement, "RUBY");
	if (ruby) {
		tinymce.each(ruby.childNodes, function (node) {
			var normalized_node_name = node.nodeName.toUpperCase();
			if (normalized_node_name == "RB") {
				base = node;
				return;
			} else if (normalized_node_name == "RP") {
				/* ignore */
			} else if (normalized_node_name == "RT") {
				/* ignore */
			} else {
				bases = bases.concat(node);
			}
		});
	}

	if (base || bases.length > 0) {
		var parent = ruby.parentNode;
		var rest_nodes = [];

		tinyMCEPopup.execCommand('mceBeginUndoLevel');
		if (base)
			rest_nodes = base.childNodes;
		if (rest_nodes.length == 0)
			rest_nodes = bases;
		tinymce.each(rest_nodes, function (node) {
			parent.insertBefore(node, ruby);
		});
		parent.removeChild(ruby);
		SXE.inst.nodeChanged();
		tinyMCEPopup.execCommand('mceEndUndoLevel');
	}
	tinyMCEPopup.close();
}

tinyMCEPopup.onInit.add(init);

/*
 * Local Variables:
 * indent-tabs-mode: t
 * tab-width: 4
 * End:
 */
