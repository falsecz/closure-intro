goog.require 'goog.dom'
goog.require 'goog.ui.Button'
goog.require 'sbks.ui.Button'
goog.require 'sbks.ui.ButtonContainer'

goog.provide 'sbks.bootstrap'

sbks.bootstrap = () ->
	bc = new sbks.ui.ButtonContainer
	bc.render()
	
	button = new goog.ui.Button 'test'
	bc.addChild button, yes
	
	sb = new sbks.ui.Button 'sbks'
	bc.addChild sb, yes
	
	


