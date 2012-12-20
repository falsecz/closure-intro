(function () {

	function NinjaTurtle (name) {
		this.name = name;
	}

	NinjaTurtle.prototype.getName = function () {
		return this.name;
	}

	NinjaTurtle.prototype.uselessMethod = function () {
		return 'nonsense';
	}


	var mike = new NinjaTurtle('Michelangelo');

	console.log(mike.getName());

})();
