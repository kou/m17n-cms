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
		var elm = SXE.inst.dom.getParent(SXE.focusElement, "RUBY");

		if (elm) {
			var rt = null;
			tinymce.each(elm.childNodes, function (node) {
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

function setAllCommonAttribs(elm) {
	var dom = SXE.inst.dom;
	var parentheses = [];
	var text = null;
	var base = null;
	var bases = [];

	tinymce.each(elm.childNodes, function (node) {
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
		elm.appendChild(base);
	}

	tinymce.each(parentheses, function (node) {
		elm.removeChild(node);
	});

	if (text) {
		var new_text;

		new_text = dom.create("rt", {}, getFormValue("ruby"));
		elm.replaceChild(new_text, text);
		text = new_text;
	} else {
		text = dom.create("rt", {}, getFormValue("ruby"));
		elm.appendChild(text);
	}

	elm.insertBefore(dom.create("rp", {}, "（"), text);
	dom.insertAfter(dom.create("rp", {}, "）"), text);
}

function insertRuby() {
	alert("insert");
	alert(document.forms[0].elements["ruby"].value);
	SXE.insertElement('ruby');
	tinyMCEPopup.close();
}

function removeRuby() {
	alert("remove");
	SXE.removeElement('ruby');
	tinyMCEPopup.close();
}

tinyMCEPopup.onInit.add(init);

/*
 * Local Variables:
 * indent-tabs-mode: t
 * tab-width: 4
 * End:
 */
