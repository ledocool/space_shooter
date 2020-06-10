class_name PickupHelper

static func ProcessPickup(item, inventory, statusTarget, statusArray) -> bool:
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
			var statusName = StatusMap.getStatusPath(item.get_name())
			if (!statusName.empty()):
				if(statusTarget.ShipCurrentHealth < statusTarget.ShipMaxHealth):
					var status = load(statusName)
					statusArray.append(status.new(statusTarget))
					return true

			return false
	print_debug("Item of unknown type: " + String(item.get_type()))
	return false;
