extends Node2D


class inPolygonRandomPointGenerator:
	var _polygon: PoolVector2Array
	var _triangles: PoolIntArray
	var _cumulated_triangle_areas: Array

	var _rand: RandomNumberGenerator

	func _init(polygon: PoolVector2Array) -> void:
		_polygon = polygon
		_triangles = Geometry.triangulate_polygon(_polygon)	
		#_init_cumulated_triangle_areas()
		_rand = RandomNumberGenerator.new()
		
		var triangle_count: int = _triangles.size() / 3
		assert(triangle_count > 0)
		_cumulated_triangle_areas.resize(triangle_count)
		_cumulated_triangle_areas[-1] = 0
		for i in range(triangle_count):
			var a: Vector2 = _polygon[_triangles[3 * i + 0]]
			var b: Vector2 = _polygon[_triangles[3 * i + 1]]
			var c: Vector2 = _polygon[_triangles[3 * i + 2]]
			_cumulated_triangle_areas[i] = _cumulated_triangle_areas[i - 1] + triangle_area(a, b, c)

			
	func get_random_point() -> Vector2:
		var total_area: float = _cumulated_triangle_areas[-1]
		var choosen_triangle_index: int = _cumulated_triangle_areas.bsearch(_rand.randf() * total_area)
		var a: Vector2 = _polygon[_triangles[3 * choosen_triangle_index + 0]]
		var b: Vector2 = _polygon[_triangles[3 * choosen_triangle_index + 1]]
		var c: Vector2 = _polygon[_triangles[3 * choosen_triangle_index + 2]]
		
		while true:
			if (a.distance_to(b) <= 500 or a.distance_to(c) <= 500 or b.distance_to(c) <= 500):
				choosen_triangle_index = _cumulated_triangle_areas.bsearch(_rand.randf() * total_area)
				a = _polygon[_triangles[3 * choosen_triangle_index + 0]]
				b = _polygon[_triangles[3 * choosen_triangle_index + 1]]
				c = _polygon[_triangles[3 * choosen_triangle_index + 2]]
				continue
			else:
				break
		
		return random_triangle_point(a, b, c)
		

	static func triangle_area(a: Vector2, b: Vector2, c: Vector2) -> float:
		return 0.5 * abs((c.x - a.x) * (b.y - a.y) - (b.x - a.x) * (c.y - a.y))

	static func random_triangle_point(a: Vector2, b: Vector2, c: Vector2) -> Vector2:
		return a + sqrt(randf()) * (-a + b + randf() * (c - b))



# Called when the node enters the scene tree for the first time.
func _ready():
	#var generateRandomPoints = inPolygonRandomPointGenerator.new(getFreeArea())
	#print(generateRandomPoints.get_random_point())
	#var poly = Polygon2D.new()
	#poly.set_polygon(Geometry.clip_polygons_2d($fullMap.polygon, $StaticBody2D.get_child(0).polygon)[0])
	#poly.set_polygon(getFreeArea())
	#add_child(poly)
	#getFreeArea()
#	print($StaticBody2D.get_child_count())
#	mergePolygons()
#	print($StaticBody2D.get_child_count())
#	getFreeArea()
	
	yield(get_tree(), "idle_frame")
	#var path = $Navigation2D.get_simple_path(Vector2(randi() % (3968 + 17664) - 3968, randi() % (4544 + 10496) - 4544), Vector2(randi() % (3968 + 17664) - 3968, randi() % (4544 + 10496) - 4544))
	#var path = $Navigation2D.get_simple_path($Position2D.position, $Position2D2.position)
	#print($Position2D.position, $Position2D2.position)
	#$Line2D.points = path
	#$Line2D.show_on_top
	#print(path)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	pass

func getFreeArea():
#	var freeMap = $fullMap.polygon
#	#print(freeMap)
#	#print($StaticBody2D.get_child_count())
#	var np = NavigationPolygon.new()
#	var inner_holes = []
#	for i in $StaticBody2D.get_children():
#		freeMap = Geometry.clip_polygons_2d(freeMap, i.polygon)
#		if len(freeMap) != 1:
#			inner_holes.append(freeMap[1])
#
#		freeMap = freeMap[0]
#
#	#print(freeMap)
#	#print(inner_holes[0])
#
#	np.add_outline(freeMap)
#	for poly in inner_holes:
#		print(poly)
#		np.add_outline(poly)
#	np.make_polygons_from_outlines()
#	var npi = NavigationPolygonInstance.new()
#	npi.navpoly = np
#	$Navigation2D.add_child(npi)
#
#	print(inner_holes)
#	#print(freeMap)
#	return freeMap
	
	var freeMap = $fullMap.polygon
	#print(freeMap)
	#print($StaticBody2D.get_child_count())
	var np = NavigationPolygon.new()
	var inner_holes = []
	for i in $StaticBody2D2.get_children():
		freeMap = Geometry.clip_polygons_2d(freeMap, i.polygon)
		if len(freeMap) != 1:
			inner_holes.append(freeMap[1])

		freeMap = freeMap[0]
	
	#print(freeMap)
	#print(inner_holes[0])
	
	np.add_outline(freeMap)
	for poly in inner_holes:
		#print(poly)
		np.add_outline(poly)
	np.make_polygons_from_outlines()
	var npi = NavigationPolygonInstance.new()
	npi.navpoly = np
	$Navigation2D.add_child(npi)
	
	#print(inner_holes)
	#print(freeMap)
	return freeMap


func mergePolygons():
	var polygons_to_remove:Array
	while(true):
		polygons_to_remove = []
		var child_num = $StaticBody2D.get_child_count()
		for child_index in range(child_num):
			
			if child_index == child_num - 1:
				break
			
			var child = $StaticBody2D.get_child(child_index)
			child.set_build_mode(1)
			#print(child)
			var found_polygon:CollisionPolygon2D = child as CollisionPolygon2D
			if found_polygon == null or found_polygon.is_queued_for_deletion():
				continue

			if found_polygon.transform != Transform2D.IDENTITY:
				var transformed_polygon = found_polygon.transform.xform(found_polygon.polygon)
				found_polygon.transform = Transform2D.IDENTITY
				found_polygon.polygon = transformed_polygon

			for child_subindex in range(child_index+1, child_num):
				var other_child = $StaticBody2D.get_child(child_subindex)
				other_child.set_build_mode(1)
				var other_found_polygon:CollisionPolygon2D = other_child as CollisionPolygon2D
				if other_found_polygon == null or other_found_polygon.is_queued_for_deletion():
					continue
				if other_found_polygon.transform != Transform2D.IDENTITY:
					var other_transformed_polygon = other_found_polygon.transform.xform(other_found_polygon.polygon)
					other_found_polygon.transform = Transform2D.IDENTITY
					other_found_polygon.polygon = other_transformed_polygon
				
				var merged_polygon = Geometry.merge_polygons_2d(found_polygon.polygon, other_found_polygon.polygon)
				if merged_polygon.size() != 1:
					#print(merged_polygon)
					continue
				else:
					other_found_polygon.polygon = merged_polygon[0]
					polygons_to_remove.append(found_polygon)
					break

		if polygons_to_remove.size() == 0:
			print("Done merging polygons!")
			break

		for polygon_to_remove in polygons_to_remove:
			#print(polygon_to_remove)
			polygon_to_remove.free()
	
	#print($StaticBody2D.get_children())

