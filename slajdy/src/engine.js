var Engine = function (type) {
	this.type = type;
}

Engine.prototype.getType = function () {
	console.log('I\'m ' + this.type + ' engine');
}

var v8 = new Engine('v8');
v8.getType(); // works
setTimeout(v8.getType, 500); // nope...
