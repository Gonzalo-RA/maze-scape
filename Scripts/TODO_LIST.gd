extends Node


## There's a problem when I update and reload.
	## I fixed it adding a is_reload variable in inventory_.gd
	## but still, when I add some item into the Equiped inventory, there's a bug.
	## it happes only after that I "reolad".
	## However, When it reloads, it undressed, and it's not right.
	## Also we cannot remove the already located item.
	## I must to figure out how to do it.


var TO_DO = {
	'DRINK_POTION' : {
		'done' : true ,
	},
	'EQUIPEMENT_' : {
		'done' : true,
		'SCROLLS' : 'Falta saber que vamos a hacer con Scrolls',
	},
	'INVERTORY' : {
		'done' : false,
		'Space' : 'If enought space in Inventory ... ',
		'Replace' : 'If Item dragued, then replace item under pointer',
		'PickUp' : "Only Pick up item if there's enough space in inventory",
	},
	'ENEMY' : {
		'done' : true,
		'enemyMover' : 'enemies move rarelly and dont akkack up nor down. Create a better mover and anumation' ,
		'enemyMover_2' : 'They are still very silly moving inside a the labyrynth, they collyde with the walls',
	},
	'DEAD' : {
		'done' : false,
		'Update' : 'Update Inventary and other stuff after dead' ,
	},
	'NEW_STAGE' : {
		'done': false,
		'scene switcher' : 'https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html',
	},
	'WORLD_MAP': {
		'done' : false,
		'ciudades' : 'mapa de ciudad',
		'continente' : { 
			'que' : 'mapa de continente (o al menos de alguna geografía)',
			'Figurar' : 'como el pj encontrará dificultades en el camino ( Estilo Final Fantasy o Estilo ... Legend Of Void o mixto, o estilo Zelda)'
			}
		},
	'SOUND' : false ,
	'PRESENTATION' : false,
	'SAVE_GAME' : {
		'done' : false,
		'save' : 'JSON file ? '
	}
}


