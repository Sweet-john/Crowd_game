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
	getFreeArea()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func getFreeArea():
	var freeMap = $fullMap.polygon
	#print(freeMap)
	#print($StaticBody2D.get_child_count())
	var np = NavigationPolygon.new()
	var inner_holes = []
	for i in $StaticBody2D.get_children():
		freeMap = Geometry.clip_polygons_2d(freeMap, i.polygon)
		if len(freeMap) != 1:
			inner_holes.append(freeMap[1])
		freeMap = freeMap[0]
	#print(inner_holes)
	#print(freeMap)
	return freeMap
