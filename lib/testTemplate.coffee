module.exports =
	get: (tests) ->
		requires = []
		for test, enabled of tests
			requires.push "goog.require('#{test}')"
		 
		return """
<!DOCTYPE html>
<html>
<head>
	<title>Jasmine test runner</title>
	<meta charset="utf-8" />
	<style type="text/css">
		#suites {
			font-size: 11px;
			font-family: Monaco, "Lucida Console", monospace;
			line-height: 14px;
			color: #333;
			padding-left: 8px;
		}
		#suites a{
			color: #333;
		}
		
		.builderdemos {
			font-family: "Trebuchet MS", Tahoma, Verdana, sans-serif;
			font-size: 14px;
			margin-bottom: 20px;
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
		
		body {
			background-image: url('http://wondersofdisney.yolasite.com/resources/toondis/gummi/toadwart.png');
			background-repeat: no-repeat;
			background-attachment: fixed;
			background-position: right 10px;
			margin-right: 140px !important;
		}
	</style>

<!--	<script type="text/javascript" src="{$baseUrl}/js/coffee-script.js"></script> -->

  <link rel="shortcut icon" type="image/png" href="/app/vendor/jasmine/jasmine-1.2.0.rc/jasmine_favicon.png">
  <link rel="stylesheet" type="text/css" href="/app/vendor/jasmine/jasmine-1.2.0.rc3/jasmine.css">
  <script type="text/javascript" src="/app/vendor/jasmine/jasmine-1.2.0.rc3/jasmine.js"></script>
  <script type="text/javascript" src="/app/vendor/jasmine/jasmine-1.2.0.rc3/jasmine-html.js"></script>

	<script src="../vendor/closure/closure/goog/base.js" type="text/javascript" ></script>
	<script src="../js/closure-deps.js" type="text/javascript" ></script>






<script>

//goog.require('builder.test.model.repository.Departments');
#{requires.join('\n')}

</script>

</head>
<body>

		
	  <script type="text/javascript">


	var spyOnCallback, waitsForCallback;

	spyOnCallback = function(object, key) {
	  var cb;
	  spyOn(object, key).andCallThrough();
	  cb = jasmine.createSpy();
	  cb.waitAsync = function(validate) {
	    return waitsForCallback(cb, 'response', validate);
	  };
	  return cb;
	};

	waitsForCallback = function(cb, message, validate) {
	  waitsFor((function() {
	    return cb.callCount === 1;
	  }), message, 10000);
	  return runs(function() {
	    return validate.apply(null, cb.mostRecentCall.args);
	  });
	};




	    (function() {
	      var jasmineEnv = jasmine.getEnv();
	      jasmineEnv.updateInterval = 1000;

	      var htmlReporter = new jasmine.HtmlReporter();

	      jasmineEnv.addReporter(htmlReporter);

	      jasmineEnv.specFilter = function(spec) {
  			if(document.location.search.match('spec=all')) {
				return true;
  			}
			  
			 //console.log(spec.description);
	        return htmlReporter.specFilter(spec);
			// console.log (x);
			// return x
	      };

	      var currentWindowOnload = window.onload;

	      window.onload = function() {
	        if (currentWindowOnload) {
	          currentWindowOnload();
	        }
			var runner = jasmineEnv.currentRunner();
			var suites = runner.suites();
			var sel = document.getElementById('suites');
			for(var i=0; i < suites.length; i++) {
				var s = suites[i].description
				sel.innerHTML += '<li><a href="?spec=' + s + '">' + s +'</a><br/>';
			}
			if(document.location.search.match('spec=')) {
			   execJasmine();
			}
	      };

	      function execJasmine() {
	        jasmineEnv.execute();
	      }

	    })();
	  </script>
	  <div id="suites">
	 	 <li><a href="?spec=all">Run all</a><br/>
	  </div>
	  
</body>
</html>
		"""