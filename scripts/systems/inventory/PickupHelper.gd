class_name PickupHelper

static func ProcessPickup(item, inventory, statusTarget, statusWorker) -> bool:
	match(item.get_type()):
		0:
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
			
		1:
			if (item.get_info().has("status")):
				if(item.get_info().status is Status):
					var status = item.get_info().status
					if(status && status.CanApply(statusTarget)):
						statusWorker.AddStatus(status)
						return true
					
			return false
	print_debug("Item of unknown type: " + String(item.get_type()))
	return false;
