extends Control

var isOpen: bool = false

func open():
	visible = true
	isOpen = true
	
func closed():
	visible = false
	isOpen = false
	
