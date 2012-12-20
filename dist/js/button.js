
(function() {
goog.provide('sbks.ui.Button');


goog.scope(function() {
  
    var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; 
  child.superClass_ = parent.prototype; 
  return child; 
};

  goog.require('goog.ui.Button');

  sbks.ui.Button = (function(_super) {
    var $private;

    __extends(Button, _super);

    $private = '$sbks_ui_Button_';

    function Button() {
      this.$sbks_ui_Button_toggleClass = __bind(this.$sbks_ui_Button_toggleClass, this);
      Button.__super__.constructor.apply(this, arguments);
    }

    Button.prototype.createDom = function() {
      Button.__super__.createDom.apply(this, arguments);
      return this.$sbks_ui_Button_toggleClass();
    };

    Button.prototype.$sbks_ui_Button_toggleClass = function() {
      return goog.dom.classes.toggle(this.getElement(), 'violet');
    };

    Button.prototype.enterDocument = function() {
      var _this = this;
      Button.__super__.enterDocument.apply(this, arguments);
      return this.getHandler().listen(this, goog.ui.Component.EventType.ACTION, function() {
        return _this.$sbks_ui_Button_toggleClass();
      });
    };

    return Button;

  })(goog.ui.Button);

}); // close goog.scope()        
}).call(this);
