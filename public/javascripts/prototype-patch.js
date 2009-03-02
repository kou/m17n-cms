// Workaround for Prototype 1.6.0.3 with Ext JS on IE 7.
//   http://extjs.com/forum/showthread.php?p=85148#post85148

if(window.Event) {
    Object.extend(Event,{
        element: function(event) {
          var node = Event.extend(event).target;
          return node && Element.extend(node.nodeType == Node.TEXT_NODE ? node.parentNode : node);
        },

        pointer: function(event) {
          return {
            x: event.pageX || (event.clientX +
              ((document && document.documentElement && document.documentElement.scrollLeft)
                  || (document && document.body && document.body.scrollLeft))),
            y: event.pageY || (event.clientY +
              ((document && document.documentElement && document.documentElement.scrollTop)
                  || (document && document.body && document.body.scrollTop)))
          };
        }
    });
}
