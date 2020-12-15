extends Node2D

var TextReplacement

func _ready():
	TextReplacement = $RichTextLabel.text
	Translate()

func Translate():
	$RichTextLabel.text = tr(TextReplacement)
