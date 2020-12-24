extends Node2D

var TextReplacement

func _ready():
	TextReplacement = ($RichTextLabel as RichTextLabel).text
	Translate()

func Translate():
	($RichTextLabel as RichTextLabel).text = tr(TextReplacement)
