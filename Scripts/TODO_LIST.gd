extends Node


## There's a problem when I update and reload.
	## I fixed it adding a is_reload variable in inventory_.gd
	## but still, when I add some item into the Equiped inventory, there's a bug.
	## it happes only after that I "reolad".
	## However, When it reloads, it undressed, and it's not right.
	## Also we cannot remove the already located item.
	## I must to figure out how to do it.

## Concretamnete:
	## En este momento el inventario no se acutualiza cuando el PJ muere y vuelve.
	
	## Tarea :
		# (DONE) -  Aprender a eliminar los artículos "equipados" 
		# -  Cuando el Hero muere, los items contnidos en Equiped.items {} deben ser elimindados 
			# (DONE) Controlar que : desde Equiped.items también se elimen en slots. 
			# (DONE) Equiped.items = {} (empty) 
			# (DONE) Logré elimiar los items Equiped.items ... 
			# (DONE) Pero hay que eliminar también la animación. 
				# (DONE) solo quedan las botas... no se van.
			# (DONE) for slot in slots: items[slot.name] = null (empty slots) 
			# (DONE) también en el BackPack.Back_Pack (elimiarlos de la lista pot el nombre como KEY) 
			# (DONE) Hay algunos items que desaparecen cuando se incorporan nuevamente al equipo
		# - (DONE)  Observar tecnica antigua "esparcir los artículos perdidos".
			# (DONE) Está funcionando pero hay un error al momento de "Reload"
		# - (DONE)  Aprender a recobrar los artículos "equipados"
				# Esto me ayudará a entender como salvar y cargar nuevamente estos artículos
		# - (DONE) Aprender a "bestir" y "desvestir" los artículos perdidos y cargados
		# - (DONE) Hay un error con las botas, que no de "desvisten".
	
	## Cuando pueda vestir y desvestir al personaje. Sabré como cargarlo cuando se se "salva".
	
	## SAVE & LOAD
		# (DONE) Se ha revisado las funciones Save & Load
		# (DONE) Save guarda en Diccionario.
		# (DONE) Sin embargo todo se guarda en texto!! Ojo con los valores del personaje.
		# (DONE) Transformar e instanciar los elelemntos Equiped en objetos 
		# (DONE) Crearles una textura
		# (DONE) e insertarlos en los Sots (Equiped)
		# (DONE) Hacer lo mismo con el resto de los objetos (no Equiped)
		## Los elementos se guardan y cargan bien. Sin embargo hay un error al cargarlos una segunda vez
		# (DONE) Revisar el error cuando se cargan por segunda vez los items
		## (!!!) HAy un problema con "Save & Load" de las pociones "agrupadas" (stack)
		# ---- Creo que hay que eliminar los elementos de items en GridBackPack también. Es ahí que quesan instanciados.
		# (----) Además eliminarlos del Back Pack también.
		# (DONE) Hacer limpieza de todas las instancias de elementos del inventarios
		# (----) Así, eliminarlos del (BckPck, GridBckPck, Equiped, hero_data.Equiped_items), etc. 
		# (----) También eliminarlos de manera "instancial", es decir, como nodo, textura e instancia.
		# (DONE) Incorporar "in the flow" los elementos que van "Equipados" a los Slots de equipo (si no, ocupan mucho espacio en los slots del Inventario)
		# (DONE) Los Slots de equipamiento parecen ocupados al momento de cargar. Identificar el problema
		## (!!!) Cuando una etapa se carga (Load) una segunda o trercera vez, en la misma etapa, los enemigos y los items se multiplican. 
	

var TO_DO = {
	'DRINK_POTION' : {
		'done' : true ,
	},
	'SOLVE FUNCTION' : {
		'function' : 'return_items() : hero_data.remove_item(item)',
		'location' : 'Hero.gd'
		## Ya se modificó remove_items en Hero_data() 
		## Luego de eso habrá que revisar Save() & Load() 
		## Además de "return_items"
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


