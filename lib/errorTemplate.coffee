module.exports = (errors) -> 
		errorHtml = []
		for err in errors
			errorHtml.push "<h2>In #{err.file} on line #{err.line}</h2>"
			errorHtml.push "<p id=\"detail\">#{err.message}</p>"
			for code, line in err.context
				currentLine = line + err.offset + 1
				errorHtml.push """
				<pre class="#{if currentLine == err.line then "error" else ""}"><span class="line">#{currentLine}</span><span class="code">#{code}<span class="marker"></span></span></pre>"""

		return """<!DOCTYPE html>
<html>
	<head>
		<title>@error.title</title>
		<link rel="shortcut icon" href="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAlFJREFUeNqUU8tOFEEUPVVdNV3dPe8xYRBnjGhmBgKjKzCIiQvBoIaNbly5Z+PSv3Aj7DSiP2B0rwkLGVdGgxITSCRIJGSMEQWZR3eVt5sEFBgTb/dN1yvnnHtPNTPG4PqdHgCMXnPRSZrpSuH8vUJu4DE4rYHDGAZDX62BZttHqTiIayM3gGiXQsgYLEvATaqxU+dy1U13YXapXptpNHY8iwn8KyIAzm1KBdtRZWErpI5lEWTXp5Z/vHpZ3/wyKKwYGGOdAYwR0EZwoezTYApBEIObyELl/aE1/83cp40Pt5mxqCKrE4Ck+mVWKKcI5tA8BLEhRBKJLjez6a7MLq7XZtp+yyOawwCBtkiBVZDKzRk4NN7NQBMYPHiZDFhXY+p9ff7F961vVcnl4R5I2ykJ5XFN7Ab7Gc61VoipNBKF+PDyztu5lfrSLT/wIwCxq0CAGtXHZTzqR2jtwQiXONma6hHpj9sLT7YaPxfTXuZdBGA02Wi7FS48YiTfj+i2NhqtdhP5RC8mh2/Op7y0v6eAcWVLFT8D7kWX5S9mepp+C450MV6aWL1cGnvkxbwHtLW2B9AOkLeUd9KEDuh9fl/7CEj7YH5g+3r/lWfF9In7tPz6T4IIwBJOr1SJyIGQMZQbsh5P9uBq5VJtqHh2mo49pdw5WFoEwKWqWHacaWOjQXWGcifKo6vj5RGS6zykI587XeUIQDqJSmAp+lE4qt19W5P9o8+Lma5DcjsC8JiT607lMVkdqQ0Vyh3lHhmh52tfNy78ajXv0rgYzv8nfwswANuk+7sD/Q0aAAAAAElFTkSuQmCC">
	    <style>
		    html, body, pre {
		        margin: 0;
		        padding: 0;
		        font-family: Monaco, 'Lucida Console';
		        background: #ECECEC;
		    }
		    h1 {
		        margin: 0;
		        background: #A31012;
		        padding: 20px 45px;
		        color: #fff;
		        text-shadow: 1px 1px 1px rgba(0,0,0,.3);
		        border-bottom: 1px solid #690000;
		        font-size: 28px;
		    }
		    p#detail {
		        margin: 0;
		        padding: 15px 45px;
		        background: #F5A0A0;
		        border-top: 4px solid #D36D6D;
		        color: #730000;
		        text-shadow: 1px 1px 1px rgba(255,255,255,.3);
		        font-size: 14px;
		        border-bottom: 1px solid #BA7A7A;
		    }
		    p#detail input {
		        background: -webkit-gradient(linear, 0% 0%, 0% 100%, from(#AE1113), to(#A31012));
                border: 1px solid #790000;
                padding: 3px 10px;
                text-shadow: 1px 1px 0 rgba(0, 0, 0, .5);
                color: white;
                border-radius: 3px;
                cursor: pointer;
                font-family: Monaco, 'Lucida Console';
                font-size: 12px;
                margin: 0 10px;
                display: inline-block;
                position: relative;
                top: -1px;
		    }
		    h2 {
		        margin: 0;
		        padding: 5px 45px;
		        font-size: 12px;
		        background: #333;
		        color: #fff;
		        text-shadow: 1px 1px 1px rgba(0,0,0,.3);
		        border-top: 4px solid #2a2a2a;
		    }
			pre {
				margin: 0;
				border-bottom: 1px solid #DDD;
				text-shadow: 1px 1px 1px rgba(255,255,255,.5);
				position: relative;
				font-size: 12px;
				overflow: hidden;
			}
			pre span.line {
			    text-align: right;
			    display: inline-block;
			    padding: 5px 5px;
			    width: 30px;
			    background: #D6D6D6;
			    color: #8B8B8B;
			    text-shadow: 1px 1px 1px rgba(255,255,255,.5);
			    font-weight: bold;
			}
			pre span.code {
			    padding: 5px 5px;
			    position: absolute;
			    right: 0;
			    left: 40px;
			}
			pre:first-child span.code {
			    border-top: 4px solid #CDCDCD;
			}
			pre:first-child span.line {
			    border-top: 4px solid #B6B6B6;
			}
			pre.error span.line {
			    background: #A31012;
			    color: #fff;
			    text-shadow: 1px 1px 1px rgba(0,0,0,.3);
			}
			pre.error {
				color: #A31012;
			}
			pre.error span.marker {
				background: #A31012;
				color: #fff;
				text-shadow: 1px 1px 1px rgba(0,0,0,.3);
			}
		</style>
	</head>
	<body>
		<h1>Compilation errors</h1>
		#{errorHtml.join "\n"}
	</body>
</html>"""

