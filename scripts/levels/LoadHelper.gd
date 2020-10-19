class_name LoadHelper


static func StringToVector2(strigifiedVector: String) -> Vector2:
	var vector = strigifiedVector.trim_prefix('(').trim_suffix(')').split(',')
	return Vector2(vector[0], vector[1])
