class_name PickupHelper

static func ProcessPickup(item, inventory, target, statusWorker, position) -> bool:
	match(item.get_type()):
		0:	#weapon
			var data = inventory.GetWeapon(item.get_name())
			if(!data):
				return false
				
			if(data.enabled):
				var quantity = item.get_quantity()
				var ammo = item.get_info().get("ammo", 0) * quantity
				return inventory.RestockWeapon(item.get_name(), ammo)
			else:
				data.enabled = true
				var result = inventory.SetWeapon(item.get_name(), data)
				return result
			
		1:	#bonus item
			if (item.get_info().has("status")):
				if(item.get_info().status is Status):
					var status = item.get_info().status
					if(status && status.CanApply(target)):
						statusWorker.AddStatus(status)
						return true
			return false
		3:	#key
			var info: Dictionary = item.get_info()
			var instanceName = info.get("class", null)
			var instance = load(instanceName)
			if(instance == null):
				return false
			
			var dt = instance.instance()
			dt.SpawnAt(position)
			target.AddKey(dt)
			return true
	print_debug("Item of unknown type: " + String(item.get_type()))
	return false;
