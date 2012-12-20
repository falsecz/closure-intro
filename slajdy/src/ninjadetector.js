var Human = function (name) {
    this.name = name;
}    
     
Human.prototype.getName = function () {
	return this.name;
} 


var Ninja = function (name, weapon) {
	this.name = name;
	this.weapon = weapon;
}

Ninja.prototype = new Human;
Ninja.prototype.constructor = Ninja;

Ninja.prototype.getWeapon = function () {
	return this.weapon;
}


var man1 = new Human('František');
var man2 = new Human('Slavoj');
var ninja1 = new Ninja('Václav', 'katana');
var ninja2 = new Ninja('Rudolf', 'shuriken');
var possibleNinjas = [man1, man2, ninja1, ninja2];

for (var i = 0, l = possibleNinjas.length; i < l; i++) {
	var maybeNinja = possibleNinjas[i];
	var about = '';

	if (maybeNinja instanceof Human) {
		about += maybeNinja.getName();
	}
	if (maybeNinja instanceof Ninja) {
		about += ' is ninja and his weapon of choice is ' + maybeNinja.getWeapon();
	}
	else {
		about += ' isn\'t ninja';
	}

	console.log(about);
}

