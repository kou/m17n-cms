// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function toolbarItemsSetLinkHandler(items) {
  Ext.each(items, function(item) {
    if (item.href)
      item.handler = function() {document.location = item.href};
  });
}
