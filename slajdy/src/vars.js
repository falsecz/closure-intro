var arr = [true, false, 8, 010, 1.1, 'b', "B", null, undefined];
for (var i = 0; i < arr.length; i++) {
	    console.log('arr[' + i + '] = ' + arr[i]);
}

var obj = {prop1: 'one'};
obj['prop2'] = 'two';
obj.prop3 = 'three';
for (var key in obj) {
	    console.log('obj.' + key + ' = ' + obj[key]);
}

