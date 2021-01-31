extends CanvasLayer
class_name Overlay

func ShowModal(text: String):
# warning-ignore:unsafe_method_access
	find_node("Modal").Show(text)
# warning-ignore:unsafe_method_access
	find_node("TimedNotification").Hide()


func ShowTimedNotificatiopn(text: String, duration: float = 1):
# warning-ignore:unsafe_method_access
	find_node("TimedNotification").Show(text, duration)


func HideTimedNotification():
# warning-ignore:unsafe_method_access
	find_node("TimedNotification").Hide()


func ShowChangeBtnPopup(action: String):
# warning-ignore:unsafe_method_access
	find_node("ChangeBtnPopup").Show(action)
	
