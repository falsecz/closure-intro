goog.require 'goog.ui.Button'


class sbks.ui.Button extends goog.ui.Button
	constructor: ->
		super

	createDom: ->
		super
		@_toggleClass()
			
	_toggleClass: =>
		goog.dom.classes.toggle @getElement(), 'violet'
		
	enterDocument: ->
		super
		@getHandler().listen @, goog.ui.Component.EventType.ACTION, =>
			@_toggleClass()