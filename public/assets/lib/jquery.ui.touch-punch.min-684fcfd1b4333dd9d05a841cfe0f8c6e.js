/*!
 * jQuery UI Touch Punch 0.1.0
 *
 * Copyright 2010, Dave Furfero
 * Dual licensed under the MIT or GPL Version 2 licenses.
 *
 * Depends:
 *  jquery.ui.widget.js
 *  jquery.ui.mouse.js
 */
(function(e){function o(t){var n=t.originalEvent.changedTouches[0];return e.extend(t,{type:s[t.type],which:1,pageX:n.pageX,pageY:n.pageY,screenX:n.screenX,screenY:n.screenY,clientX:n.clientX,clientY:n.clientY})}e.support.touch=typeof Touch=="object";if(!e.support.touch)return;var t=e.ui.mouse.prototype,n=t._mouseInit,r=t._mouseDown,i=t._mouseUp,s={touchstart:"mousedown",touchmove:"mousemove",touchend:"mouseup"};t._mouseInit=function(){var e=this;e.element.bind("touchstart."+e.widgetName,function(t){return e._mouseDown(o(t))}),n.call(e)},t._mouseDown=function(t){var n=this,i=r.call(n,t);return n._touchMoveDelegate=function(e){return n._mouseMove(o(e))},n._touchEndDelegate=function(e){return n._mouseUp(o(e))},e(document).bind("touchmove."+n.widgetName,n._touchMoveDelegate).bind("touchend."+n.widgetName,n._touchEndDelegate),i},t._mouseUp=function(t){var n=this;return e(document).unbind("touchmove."+n.widgetName,n._touchMoveDelegate).unbind("touchend."+n.widgetName,n._touchEndDelegate),i.call(n,t)}})(jQuery);