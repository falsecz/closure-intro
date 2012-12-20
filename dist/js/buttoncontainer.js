
(function() {
goog.provide('sbks.ui.ButtonContainer');


goog.scope(function() {
  
    var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; 
  child.superClass_ = parent.prototype; 
  return child; 
};

  goog.require('goog.ui.Component');

  sbks.ui.ButtonContainer = (function(_super) {
    var $private;

    __extends(ButtonContainer, _super);

    $private = '$sbks_ui_ButtonContainer_';

    function ButtonContainer() {
      ButtonContainer.__super__.constructor.apply(this, arguments);
    }

    ButtonContainer.prototype.createDom = function() {
      ButtonContainer.__super__.createDom.apply(this, arguments);
      this.$sbks_ui_ButtonContainer_titleEl = goog.dom.createDom('div', {}, 'click on button');
      return goog.dom.appendChild(this.getElement(), this.$sbks_ui_ButtonContainer_titleEl);
    };

    ButtonContainer.prototype.enterDocument = function() {
      var _this = this;
      ButtonContainer.__super__.enterDocument.apply(this, arguments);
      return this.getHandler().listen(this, goog.ui.Component.EventType.ACTION, function(e) {
        return goog.dom.setTextContent(_this.$sbks_ui_ButtonContainer_titleEl, e.target.getContent() + " button clicked");
      });
    };

    return ButtonContainer;

  })(goog.ui.Component);

}); // close goog.scope()        
}).call(this);
