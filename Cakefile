{spawn, exec} = require('child_process')
fs = require('fs')
rimraf = require('rimraf')
util = require('util')
read = require('read')
build = require('./lib/build')

# Tasks
task 'jsdoc', 'Generate javascript doc', ->
	runCmd 'jsduck --output=www/doc www/js/dist/closure/', () ->

# Tasks
task 'build', 'Build', ->
	runNette 'Build:Default:default'
		

task 'watch', 'Watch and autorecompile app', ->
	invoke 'clean'
	build.compile yes

task 'build', 'Build app', ->
	invoke 'clean'
	build.compile no


task 'minify', 'Build and minify', ->
	invoke 'clean'
	build.compile no, yes





OUT_JS =  __dirname + '/www/js/dist/builder-min.js'
OUT_CSS =  __dirname + '/www/js/dist/closure/style-compiled-min.css'

# task 'deminify', 'Clean minified js', ->
# 	fs.unlink OUT_JS, ->
# 		util.log 'JS deminified'
# 	fs.unlink OUT_CSS, ->
# 		util.log 'CSS deminified'
# 





























# Tasks
task 'clean', 'Clean temp', (callback) ->
	rimraf.sync __dirname + '/dist/'
	
	# logError = (err) -> util.log err if err
	# fileExists = (file) -> 
	# 	try 
	# 		return yes if fs.lstatSync(file).isFile() 
	# 	catch err
	# 		no
	
	# 
	# util.log 'Cleaning temp'
	# rimraf.sync __dirname + '/temp/cache/'
	# 
	# util.log 'Cleaning js distribution cache'
	# try 
	# 	jsDistDir = __dirname + '/www/js/dist/'
	# 	for tmpFile in fs.readdirSync jsDistDir
	# 		unless tmpFile.charAt(0) in ['.', '_']
	# 			rmPath = jsDistDir + tmpFile
	# 			if (fs.statSync rmPath).isDirectory()
	# 				rimraf.sync rmPath, logError
	# 			else 
	# 				fs.unlinkSync rmPath, logError
	# 	
	# 	f = jsDistDir + '.cache'
	# 	if fileExists f
	# 		fs.unlink f, logError
	# catch err
	# 	console.log err
		

task 'deploy', 'Setup deployment enviroment', ->
	invoke 'clean'
	invoke 'chmod'
	invoke 'build'

# task 'chmod', 'Chmod files according .chmod config', ->
# 	console.log 'Chmod'
# 	lines = '' + fs.readFileSync '.chmod' 
# 	lines = lines.trim().split "\n"
# 	for line in lines
# 		console.log line
# 		m = line.match /(\d\d\d) (.*)/
# 		continue unless m
# 		dir = __dirname + '/' + m[2]
# 		mask = '0' + m[1]
# 		try
# 			s = fs.statSync dir
# 		catch err
# 			fs.mkdirSync dir, mask
# 			
# 		fs.chmodSync dir, mask

OUT_JS =  __dirname + '/www/js/dist/builder-min.js'
OUT_CSS =  __dirname + '/www/js/dist/closure/style-compiled-min.css'
	
task 'deminify', 'Clean minified js', ->
	fs.unlink OUT_JS, ->
		util.log 'JS deminified'
	fs.unlink OUT_CSS, ->
		util.log 'CSS deminified'
	
task 'minifyXXXXXXX', 'Minify js', ->
	util.log 'Running CSS compressor'
	file = require 'file'
	buffer = ""
	
	path = __dirname + '/www/js/dist/closure/'
	file.walkSync path, () ->
		files = arguments[2]
		#util.log util.inspect files
		for file in files
			continue unless file.match /.css$/
			continue if file.match /compiled/
			file = arguments[0] + "/" + file
			buffer += (fs.readFileSync file).toString()
	
	stylePath =  path + 'style-compiled.css'
	
	fs.writeFileSync stylePath, buffer
	compressor = require 'node-minify'
	new compressor.minify(
		type: "yui"
		fileIn: stylePath
		fileOut: OUT_CSS
		callback: (err) ->
			console.log err if err
			util.log 'CSS minified'
	)
		
	#closure
	BUILDER_BIN =  __dirname + '/www/js/closure/closure/bin/build/closurebuilder.py' 
	JAR_PATH =  __dirname + '/www/js/closure/closure/bin/build/'          #directory containing compiler.jar
	CLOSURE_PATH =  __dirname + '/www/js/closure/'    #contains directory "closure"
	
	util.log 'Running closure compiler'
	options = 
		output_mode: 'compiled'
		root: [CLOSURE_PATH, 'www/js/dist/closure']
		input: 'www/js/dist/closure/bootstrap.js '
		compiler_jar : "#{JAR_PATH}/compiler.jar"
#		compiler_flags: '"--compilation_level=ADVANCED_OPTIMIZATIONS"'

	
	cmd = BUILDER_BIN + ' ' + mergeOptions(options) + " > #{OUT_JS}"
	# console.log cmd
	runCmd cmd
	
	
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



# ## predelat na neco co bude prubezne vypisovat vystup - exec
# runNette = (presenter) ->
# #	spawn 'php www/index.php ' + presenter
# 	action = 'www/index.php ' + presenter
# 	p = spawn 'php', action.split ' '
# 	p.stdout.on 'data', (data) ->
# 		console.log '' + data
# 
# 	p.stderr.on 'data', (data) ->
# 		console.log 'stderr: ' + data
# 
# 	p.on 'exit', (code) ->
# 		#util.log 'child process exited with code ' + code


#	runCmd 'php www/index.php ' + presenter, (a,b,c) ->
#		util.log a if a
#		util.log b if b
#		util.log c if c


runCmd = (cmd, callback, options={}) ->
	#console.warn "$ #{cmd}"  unless options.quiet?

	exec cmd, (err, stdout, stderr) ->
		callback()  if typeof callback == 'function'
		console.warn stderr  if stderr
		console.log stdout   if stdout


readInput = (prompt, cb) ->
	#read {prompt:"\033[01;33m#{prompt}\033[01;00m" }, (err, arg) -> cb arg 
	read {prompt:"#{prompt} " }, (err, arg) -> cb arg 
	
task 'init', 'Creating component in src/builder', (options) ->
	readInput 'Class name: ', (componentName='') -> 
		readInput 'Base class [goog.ui.Component]: ', (componentBase='goog.ui.Component') -> 
			readInput 'correct [y]/n: ', (correct) -> 
				return if correct isnt 'y' and  correct?

				unless componentName
					process.stderr.write 'Unknown component name!\n'
					process.exit 1
	
				path = componentName.split '.'
				if path[0] == 'builder' then path.shift() # drop 'builder' ns

				filename = path.pop().toLowerCase()

				dir = __dirname + '/src/builder'
				for subdir in path
						dir += '/' + subdir
						try 
							st = fs.statSync dir
							unless st.isDirectory() 
								process.stderr.write 'Path ' + dir + ' already exists and is not directory\n'
								process.exit 1
						catch e
							fs.mkdirSync dir, 
	
				filebase = dir + '/' + filename

				skel_map = 
					'demo.html': '_demo.html',
					'demo.coffee': '.coffee',
					'demo.less': '.less'

				componentNameCSS = 'b-' + filename.toLowerCase()

				for source, target of skel_map
					data = fs.readFileSync __dirname + '/lib/closure-component-skeleton/' + source, 'utf-8'
					data = data.replace /%componentName%/g, componentName
					data = data.replace /%componentNameCSS%/g, componentNameCSS
					data = data.replace /%componentBase%/g, componentBase

					tf = filebase + target
					fs.writeFileSync tf, data
					process.stdout.write "writing file #{tf}\n"

