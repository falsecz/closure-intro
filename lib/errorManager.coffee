formatter = require './errorTemplate'
fs = require 'fs'

loadErrorContext = (e) ->
	if e.file
		data = fs.readFileSync(e.file, 'utf-8').split '\n'
		start = if e.line > 3 then e.line - 3 else 0
		end = e.line + 3
		e.offset = start
		e.context = data[start..end]
	#console.log e
	return e

module.exports =
	format: (errors) ->
		normalizedErrors = []
		for file, err of errors
			e = {
				file: file
				line: null
				index: null
				message: ''
			}

			if /string/i.test typeof err
				e.message = err
				search = e.message.match /on line (\d+)/i
				e.line = parseInt(search[1], 10) if search.length is 2
				e.index = 0
			else
				e.message = err.message
				if e.line
					e.line = parsetInt(err.line, 10) if err.line?
				else
					search = e.message.match /on line (\d+)/i
					e.line = parseInt(search[1], 10) if search and search.length is 2
				
				e.index = err.index if err.index?

			normalizedErrors.push loadErrorContext e

		return formatter normalizedErrors
