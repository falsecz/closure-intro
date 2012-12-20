goog.require 'goog.ui.Component'

class sbks.ui.ButtonContainer extends goog.ui.Component
	constructor: ->
		super

	createDom: ->
		super
		@_titleEl = goog.dom.createDom 'div', {}, 'click on button'
		
		goog.dom.appendChild @getElement(), @_titleEl
	
	enterDocument: ->
		super
		@getHandler().listen @, goog.ui.Component.EventType.ACTION, (e)=>
			goog.dom.setTextContent @_titleEl, e.target.getContent() + " button clicked"

		
	