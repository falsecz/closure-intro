# 
# 
# hlidat soubory
# 
#	coffee
#	less
# 
# 
# 
# src/builder/ coffee less html		index.html	 admin/index.html
#	
# dist/ app.min.js style.min.css < minify
# *dist/img
# *dist/vendor/jquery
# *dist/vendor/depsure
# dist/js/	 < coffee
# dist/css/	< lessc
# dist/test/ < cp html	index pro testy	_test.html
# 
# dist/index.html
# dist/admin/index.html
# 
# deploy - img, vendor, app.min.js style.min.css

errorManager = require './errorManager'


CoffeeScript = require 'beer-script'
file = require 'file'

less = require('less')

fs = require 'fs'
path					 = require 'path'
exec = require('child_process').exec
wrench = require('wrench')
util = require 'util'
growl = require 'growl'
os = require 'os'
util = require 'util'

IS_MAC = os.platform().match /darwin/
IS_WIN = os.platform().match /win32/ or os.platform().match /win64/


APP_ROOT = __dirname + '/../'

config = 
	source: "#{APP_ROOT}/src/"	#'src'
	destination: "#{APP_ROOT}/dist"

config.jsDestination = "#{config.destination}/js/"
config.testDestination = "#{config.destination}/test/"
config.testIndexDestination = "#{config.testDestination }/index.html"
config.depsDestination = "#{config.destination}/js/closure-deps.js"
config.jsMinDestination = "#{config.destination}/js/script.min.js"

config.errorPage = "#{config.destination}/error.html"
config.demosDestination = "#{config.destination}/demo"

config.cssDestination = "#{config.destination}/css/"
config.testDestination = "#{config.destination}/test/"
config.htmlDestination = "#{config.destination}/"
config.cssMapDestination = "#{config.destination}/css/style.map.css"
config.cssMinDestination = "#{config.destination}/css/style.min.css"
config.cssCombinedDestination = "#{config.destination}/css/style.combined.css"

config.depsWriter = "#{APP_ROOT}/vendor/closure/closure/bin/build/depswriter.py"

config.vendorSource = "#{APP_ROOT}/vendor"
config.vendorDestination = "#{config.destination}/vendor"

config.imageSource = "#{APP_ROOT}/img"
config.imageDestination = "#{config.destination}/img"


wasError = yes


demoTpl = """
<!DOCTYPE html>
<html>
<head>
	<title>ui/button</title>
	<meta charset="utf-8" />
	<style type="text/css">
		.builderdemos {
			font-family: "Trebuchet MS", Tahoma, Verdana, sans-serif;
			font-size: 14px;
			margin-bottom: 20px;
		}
		li {
			padding: 10px;
		}
		.builderdemos.header {
			background-color: #7B2A90;
			color: #FFF;
			padding: 5px;
		}
		
		.builderdemos.header a {
			color: #FFF;
			float: left;
			font-weight: bold;
			text-decoration: none;
		}
		.builderdemos.header a:hover {
			color: #000;
		}
	</style>

	<script type="text/javascript" src="/app/vendor/coffee-script/coffee-script.js"></script>

	
<script src="/app/vendor/closure/closure/goog/base.js" type="text/javascript" ></script>
<script src="/app/js/closure-deps.js" type="text/javascript" ></script>
<script src="/app/vendor/jquery/jquery-1.7.2.min.js" type="text/javascript" ></script>
<script src="/app/vendor/plupload/plupload.full.js" type="text/javascript" ></script>

<link rel="stylesheet" type="text/css" href="/app/css/style.map.css" />
"""

#util.log CoffeeScript.VERSION
#return



opts =
	watch: yes
sources			= []
sourceCode	 = []
tests = {}
notSources	 = {}
demos = {}
watchers		 = {}
errors			 = {}
optionParser = null
hidden = (file) -> /^\.|~$/.test file
types = ['less', 'css', 'html', 'html', 'coffee', 'htaccess']

cp = 0
# and all subdirectories.
compilePath = (source, topLevel, base) ->
	fs.stat source, (err, stats) ->
		throw err if err and err.code isnt 'ENOENT'
		if err?.code is 'ENOENT'
			if topLevel #and source[-7..] isnt '.coffee'
				source = sources[sources.indexOf(source)] = "#{source}.coffee"
				return compilePath source, topLevel, base
			if topLevel
				console.error "File not found: #{source}"
				process.exit 1
			return
		if stats.isDirectory()
			watchDir source, base if opts.watch
			fs.readdir source, (err, files) ->
				throw err if err and err.code isnt 'ENOENT'
				return if err?.code is 'ENOENT'
				index = sources.indexOf source
				sources[index..index] = (path.join source, file for file in files)
				sourceCode[index..index] = files.map -> null
				for file in files #when not hidden file
					compilePath (path.join source, file), no, base
		else if topLevel or types.indexOf path.extname(source) > -1	 #or path.extname(source) is '.coffee'
			#util.log source, ba
			watch source, base if opts.watch
			fs.readFile source, (err, code) ->
				throw err if err and err.code isnt 'ENOENT'
				return if err?.code is 'ENOENT'
				## neni treba kompilovat prozoze uz po prvni spusteni to chytne watch
				compileScript(source, code.toString(), base)
		else
			notSources[source] = yes
			#removeSource source, base
			
#compilePath

ensureDir = (dir) ->
	base = ''
	unless IS_WIN
		base = '/'
	for p in dir.split '/'
		base += p + '/'
		try
			fs.mkdirSync base.replace /\/+/, '/'
		catch err
			throw err unless err.code is 'EISDIR' or err.code is 'EEXIST'
	
	
compileQueue = {}

removeSource = (source, base, removeJs) ->
	index = sources.indexOf source
	sources.splice index, 1
	setDoneWait() # TODO: odstranit z skompilovanjech souboru
	delete errors[source]
  
###
  sourceCode.splice index, 1
  if removeJs and not opts.join
    jsPath = outputPath source, base
    path.exists jsPath, (exists) ->
      if exists
        fs.unlink jsPath, (err) ->
          throw err if err and err.code isnt 'ENOENT'
          timeLog "removed #{source}"
###

#compileScript = (file, input, base) ->

	
compileScript = (file, input, base) ->
	#util.log file
	#return 
	return unless types.indexOf path.extname(file) > -1
	
	return unless file
	files = file.replace /\/+/, '/'
	config.src = config.source.replace /\/+/, '/'
	
	relative = path.relative config.source, files




	if file.match /_test\.coffee$/
		# dest = config.testDestination + '/' + relative
		dest = config.jsDestination + '/' + relative.replace(/\.coffee$/, '.js')
		testNamespace =  'test.' + relative.replace(/\//g,'.')
		tests[testNamespace] = 1

		input = "goog.provide '#{testNamespace}'\n#{input}"
		destDir = path.dirname dest

		ensureDir destDir
		compileCoffee file, input,	dest
	
	else if file.match /\.coffee$/
		#compileQueue[file] = 1
		dest = config.jsDestination + '/' + relative.replace(/\.coffee$/, '.js')
		destDir = path.dirname dest
		ensureDir destDir
		compileCoffee file, input,	dest

	else if file.match /\.less$/
		dest = config.cssDestination + '/' + relative.replace(/\.less$/, '.css')
		destDir = path.dirname dest
		ensureDir destDir
		compileLess file, input,	dest
	
	else if file.match /demo\.html$/
		dest = config.demosDestination + '/' + relative
		destDir = path.dirname dest
		ensureDir destDir
		compileDemoHtml file, input,	dest
		demos[file] = dest
		makeDemosIndexDelayed(demos)
	
	else if file.match /\.html$/
		dest = config.htmlDestination + '/' + relative
		destDir = path.dirname dest
		ensureDir destDir
		compileHtml file, input,	dest

	else if file.match /\.css$/  #pouze tupe zkopirovat
		dest = config.htmlDestination + '/' + relative
		destDir = path.dirname dest
		ensureDir destDir
		compileHtml file, input,	dest

		
	else if file.match /.htaccess$/  #pouze tupe zkopirovat
		dest = config.htmlDestination + '/' + relative
		destDir = path.dirname dest
		ensureDir destDir
		compileHtml file, input,	dest
	# console.log file
		
	#util.log lastCompileTime
	
doneWaiter = null

setDoneWait = ->	
	stopDoneWait()


	doneWaiter = wait 1000, ->
		util.log 'Sources compiled'


		# util.log util.inspect errors
		for file, err of errors
			# console.log "xxxx " + file 
			if file.match /.less$/
				errors[file] = null

		# generateCssMap ->
		# 	if opts.minify
		# 		minify()

		checkErrors()
		if wasError
			util.log "Error - wait for fix"
			return

		util.log 'Generating js map'
		
		x = " --root_with_prefix=\"#{config.jsDestination} ../../../../js/\" "
		# x += " --root_with_prefix=\"#{config.jsDestination} ../../../../test/\" "
		x += " --output_file=\"#{config.depsDestination}\" "
		runCmd config.depsWriter + x, (err, stdout, stderr) ->
			util.log err   if err
			util.log stdout  if stdout
			util.log stderr  if stderr
			util.log 'Js map generated'
		
			generateTests()
			
generateTests = ->
	testTemplate = require './testTemplate'
	ensureDir config.testDestination
	# util.log JSON.stringify tests
	fs.writeFileSync config.testIndexDestination, testTemplate.get(tests)
	util.log 'Tests Updated'
	
generateCssMap = (done)->			
	util.log 'Generating css map'
	# todo nepouzivat file uvnitr foru
	file = require 'file'

	buffer = ""
	file.walkSync config.source , () ->
	
		files = arguments[2]
		#util.log util.inspect files
		for file in files
			continue unless file.match /.less$/
			#p = path.relative config.jsDestination + '/../' , arguments[0]
			p = arguments[0] + '/' + file
			p = path.relative process.cwd(), p 
			# p = config.jsDestination + '/../'
			# p += '/' + file
			# pattern = /\\/g
		
			#buffer += "@import url(\"../#{p}\");\n".replace pattern , '/'
			buffer += fs.readFileSync p #"@import '#{p}';\n"   # {}(\"../#{p}\");\n".replace pattern , '/'
		
	src = config.cssMapDestination + '.tmp'
	fs.writeFileSync src, buffer
	errors[src] = null

	# stopDoneWait()
	#util.log src, dst
	# errors[config.cssMapDestination] = null

	for file, err in errors
		if file.match /.less$/
			errors[file] = null

	parser = new less.Parser 
		# paths: [path.dirname(src)]
		# filename: src

	parser.parse buffer, (err, tree) ->
		if err
			util.log util.inspect err
			errors[src] = err
			checkErrors()
			# setDoneWait()
			return
			
		try 
			css = tree.toCSS()
			ensureDir config.cssDestination 
			
			fs.writeFileSync config.cssMapDestination, css
			util.log 'Css map generated'
			#cssList[dst] = yes

			checkErrors()
			done()
			
		catch err
			util.log 'err 2'
			util.log util.inspect err

			errors[err.filename] = err
			wasError = yes
			checkErrors()
			#util.log err.message

		# setDoneWait()		
		
		
		
		



stopDoneWait = ->			
	clearTimeout doneWaiter
	

makeDemosIndex = (demos) ->
	o = {}
	for file, dest of demos
		sourceRealPath = fs.realpathSync config.source
		if file.indexOf sourceRealPath is 0
			relPath = file.substring sourceRealPath.length
		else 
			console.error "#{file} is out of #{config.source} do something about it!"
			continue
		
		pathName = relPath
		if brk = pathName.indexOf '_demo.html'
			pathName = pathName.substr 0, brk
		
		nameParts = pathName.split '/'
		name = nameParts.pop()
		group = nameParts.join '/'

		o[group] = [] unless o[group]?
		o[group].push "<li><a href=\".#{relPath}\">#{name}</a></li>"

	html = [demoTpl]
	html.push '<ul>'
	html.push "<li><strong>#{group}</strong><ul>#{links.join '\n'}</ul></li>" for group, links of o
	html.push '</ul></body></html>'

	ensureDir config.demosDestination
	outputFile = fs.openSync "#{config.demosDestination}/index.html", 'w+'
	fs.writeSync outputFile, html.join('\n'), 0
	fs.closeSync outputFile
	util.log 'Demo index regenerated'

_demoGenTimer = null
makeDemosIndexDelayed = (demos) ->
	if _demoGenTimer then clearTimeout _demoGenTimer
	_demoGenTimer  = setTimeout (-> makeDemosIndex(demos)), 5000

compileDemoHtml = (src, input, dst) ->
	stopDoneWait()
	#util.log src
	out = demoTpl + input
	fs.writeFileSync dst, out
	setDoneWait()


compileHtml = (src, input, dst) ->
	stopDoneWait()

	scripts = """
		<script src="vendor/closure/closure/goog/base.js?r=#{Math.random(20000)}" type="text/javascript" ></script>
		<script src="js/closure-deps.js?r=#{Math.random(20000)}" type="text/javascript" ></script>
		<link rel="stylesheet" type="text/css" href="css/style.map.css?r=#{Math.random(20000)}" />
	"""
	
	if opts.minify
		scripts = """
			<script src="js/script.min.js?r=#{Math.random(20000)}" type="text/javascript" ></script>
			<link rel="stylesheet" type="text/css" href="css/style.min.css?r=#{Math.random(20000)}" />
		"""
	
	input = input.replace '%SCRIPTS%', scripts

	fs.writeFileSync dst, input
	setDoneWait()

lastCompileTime = new Date()
compileCount = 0

compileCoffee = (src, input, dst) ->
	#util.log src
	#lastCompileTime = new Date()
	stopDoneWait()

	compileCount++
	
	errors[src] = null
	try
		options = 
			#bare: yes
			goog: 
				includes: []
				provides: []
			
		js = CoffeeScript.compile input, options
		fs.writeFileSync dst, js
		#checkErrors()
	catch err
		#util.log input
		#util.log 
		
		#util.log err
		errors[src] = err
		wasError = yes
		#checkErrors()

	setDoneWait()

	#compileCount--

cssList = {}

compileLess = (src, input, dst) ->
	stopDoneWait()
	setDoneWait()
	return 
# 	#util.log src, dst
# 	errors[src] = null
# 
# 	parser = new less.Parser 
# 		paths: [path.dirname(src)]
# 		filename: src
# 
# 	parser.parse input, (err, tree) ->
# 		if err
# 			errors[src] = err
# 			#checkErrors()
# 			setDoneWait()
# 			return
# 			
# 		try 
# 			css = tree.toCSS()
# 			fs.writeFileSync dst, css
# 			#cssList[dst] = yes
# 
# 			# checkErrors()
# 		catch err
# 			errors[src] = err
# 			wasError = yes
# #			checkErrors()
# 			#util.log err.message
# 
# 		setDoneWait()

checkErrors = ->
	#util.log 'crcrcr'
	out = ''
	
	growlMessage = ""
	
	found = no
	errorList = {}
	htmlPages = []
	
	for src, error of errors
		util.log src if error
		# if src.match /.html$/ 
		# 	htmlPages.push src

		continue unless error
		found = yes
		errorList[src] = error
		growlMessage = error.message + "\n"
		

	if found
		out = errorManager.format(errorList)
		fs.writeFileSync config.errorPage, out
		wasError = yes
		growl(growlMessage, { title: 'Compile error'})
		
		
	else if wasError
		wasError = no
		fs.unlink config.errorPage

		growl('OK', { title: 'Compile ok'})

# Watch a source CoffeeScript file using `fs.watch`, recompiling it every
# time the file is updated. May be used in combination with other options,
# such as `--lint` or `--print`.
watch = (source, base) ->

	prevStats = null
	compileTimeout = null

	watchErr = (e) ->
		if e.code is 'ENOENT'
			return if sources.indexOf(source) is -1
			if demos[source]? then delete demos[source] and makeDemosIndexDelayed(demos)
			try
				rewatch()
				compile()
			catch e
				removeSource source, base, yes
				#compileJoin()
		else throw e

	compile = ->
		clearTimeout compileTimeout
		compileTimeout = wait 25, ->
			#util.log source
			fs.stat source, (err, stats) ->
				return watchErr err if err
				return rewatch() if prevStats and stats.size is prevStats.size and
					stats.mtime.getTime() is prevStats.mtime.getTime()
				prevStats = stats
				fs.readFile source, (err, code) ->
					return watchErr err if err
					compileScript(source, code.toString(), base)
					rewatch()

	try
		if IS_MAC or IS_WIN
			watcher = fs.watch source, compile
		else
			watcher = fs.watchFile source, compile
	catch e
		watchErr e

	rewatch = ->
		if IS_MAC or IS_WIN
			watcher?.close()
			watcher = fs.watch source, compile
		else
			fs.unwatchFile source
			watcher = fs.watchFile source, compile


# Watch a directory of files for new additions.
watchDir = (source, base) ->
	readdirTimeout = null
	try
		watcher = fs.watch source, ->
			clearTimeout readdirTimeout
			readdirTimeout = wait 25, ->
				fs.readdir source, (err, files) ->
					# util.log util.inspect files 
					if err
						throw err unless err.code is 'ENOENT'
						watcher.close()
						return unwatchDir source, base
					for file in files when  not notSources[file]  ##not hidden(file) and##
						file = path.join source, file
						continue if sources.some (s) -> s.indexOf(file) >= 0
						sources.push file
						sourceCode.push null
						compilePath file, no, base
	catch e
		throw e unless e.code is 'ENOENT'

# Convenience for cleaner setTimeouts.
wait = (milliseconds, func) -> setTimeout func, milliseconds

unwatchDir = (source, base) ->
	prevSources = sources[..]
	toRemove = (file for file in sources when file.indexOf(source) >= 0)
	removeSource file, base, yes for file in toRemove
	return unless sources.some (s, i) -> prevSources[i] isnt s
	#compileJoin()


runCmd = (cmd, callback, options={}) ->
	#console.warn "$ #{cmd}"  unless options.quiet?

	exec cmd, callback
	# exec cmd, (err, stdout, stderr) ->
	# 	callback(err, stdout, stderr)  if typeof callback == 'function'
	# 	
		#util.log err


		#console.warn stderr  if stderr
		#util.log stdout   if stdout




minify = ->
	util.log 'Running CSS compressor'
	file = require 'file'
	# buffer = ""
	# 
	# file.walkSync config.cssDestination , () ->
	# 	files = arguments[2]
	# 	for file in files
	# 		continue if file is path.basename config.cssMapDestination
	# 		continue if file is path.basename config.cssCombinedDestination
	# 		continue if file is path.basename config.cssMinDestination
	# 		
	# 		file = arguments[0] + "/" + file
	# 		buffer += (fs.readFileSync file).toString()
	# 
	# fs.writeFileSync config.cssCombinedDestination, buffer
	compressor = require 'node-minify'
	new compressor.minify(
		type: "yui"
		fileIn: config.cssMapDestination
		fileOut: config.cssMinDestination
		callback: (err) ->
			console.log err if err
			util.log 'CSS minified'
	)

	#console.log config.jsDestination
	#return

	closureDir = config.vendorDestination + '/closure/'
	#closure
	BUILDER_BIN = "#{closureDir}/closure/bin/build/closurebuilder.py"
	
	JAR_PATH =  "#{closureDir}/closure/bin/build/"          #directory containing compiler.jar
	CLOSURE_PATH =  closureDir # closureDir + '/www/js/closure/'    #contains directory "closure"
	
	util.log 'Running closure compiler'
	options = 
		#output_mode: 'compiled'
		output_mode: 'script'
		root: [CLOSURE_PATH, config.jsDestination] #'www/js/dist/closure'
		#namespace: 'builder.Bootstrap'
		i: 'dist/js/bootstrap.js'
		compiler_jar : "#{JAR_PATH}/compiler.jar"
#		compiler_flags: '"--compilation_level=ADVANCED_OPTIMIZATIONS"'

	fs.chmodSync BUILDER_BIN, 0o777
	
	cmd = BUILDER_BIN + ' ' + mergeOptions(options) + " > #{config.jsMinDestination}"
	console.log cmd
	runCmd cmd, (err, stdout, stderr) ->
		console.log err if err
		console.log stdout if stdout
		console.log stderr if stderr
		util.log 'JS compressed'
		
		compressor = require 'node-minify'
		new compressor.minify(
			type: "yui"
			fileIn: config.jsMinDestination
			fileOut: config.jsMinDestination
			callback: (err) ->
				console.log err if err
				util.log 'JS minified'
		)
		


# Helpers

mergeOptions = (options) ->
	buffer = ''
	for name, values of options
		option = name
		if option.length > 1
			option = '-' + option

		option = '-' + option
		if typeof values is 'object'
			for value in values
				buffer += " #{option} #{value}"
		else
			buffer += " #{option} #{values}"
	buffer




spritify = (cb) =>
	spritifyDir = (dir, cb) =>
		baseDir = config.imageDestination + "/" + dir
		files = fs.readdirSync baseDir 
		# util.log util.inspect files
		# return
	
		sourceImages = []
		for file in files
			if file.match /.png$/
				sourceImages.push baseDir + "/" + file
	
		# util.log util.inspect sourceImages
		# return
		outputImages = []
		cfg = 
			outputImage: "#{dir}.png"
			outputCss: "#{dir}.less"
			outputDirectory: config.imageDestination
			# verbose: yes
			selector: ".#{dir}"
		
		# util.log util.inspect cfg
		new SpriteBuilder(sourceImages, outputImages, cfg).build () ->
			util.log 'Sprites built'
			cb()



	dirs = []
	files = fs.readdirSync config.imageDestination
	for file in files
		dirs.push file if fs.statSync(config.imageDestination + "/" + file).isDirectory() and file.match /sprite-/

	

	processedCount = 0
	# for dir in dirs
	# 	util.log "Processing sprite dir #{dir}"
	# 	spritifyDir dir, ->
	# 		processedCount++
	# 		cb() if processedCount is dirs.length
	cb()
	


	## /sprites
	








SpriteBuilder = require('node-spritesheet').Builder


module.exports.compile = (watch = no, min = no) ->
	#return minify()
	opts.watch = watch
	opts.minify = min
	
	ensureDir config.destination
	
	util.log 'Publishing vendor'
	wrench.copyDirSyncRecursive config.vendorSource, config.vendorDestination
	util.log 'Vendor published'
	util.log 'Publishing images'
	wrench.copyDirSyncRecursive config.imageSource, config.imageDestination
	util.log 'Images published'
	util.log 'Building sprites'
	spritify =>
		util.log 'Compiling sources'
		compilePath config.source
		
	
	
	

