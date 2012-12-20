
(function() {


goog.scope(function() {
  
  
  goog.require('goog.dom');

  goog.require('goog.ui.Button');

  goog.require('sbks.ui.Button');

  goog.require('sbks.ui.ButtonContainer');

  goog.provide('sbks.bootstrap');

  sbks.bootstrap = function() {
    var bc, button, sb;
    bc = new sbks.ui.ButtonContainer;
    bc.render();
    button = new goog.ui.Button('test');
    bc.addChild(button, true);
    sb = new sbks.ui.Button('sbks');
    return bc.addChild(sb, true);
  };

}); // close goog.scope()        
}).call(this);
