extends Sprite3D
class_name  Bar

@onready var progressBar : ProgressBar = $SubViewport/ProgressBar
@export var value : float
@export var shouldLerp : bool = true #false makes value be set instantly
@export var timedLerp : bool = true #false makes lerps at a constant speed for as long as needed
@export var lerpRate : float
@export var timeToLerp : float #seconds

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setMax(maxValue : float):
	progressBar.max_value = maxValue
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (value == progressBar.value):
		return

	if shouldLerp == false:
		progressBar.value = value
		return

	var diff = progressBar.value - value
	if abs(diff) < 0.01:
		progressBar.value = value
		return

	if timedLerp:
		progressBar.value = lerp(value, progressBar.value, delta/timeToLerp)
	else:
		progressBar.value = lerp(value, progressBar.value, lerpRate)
	pass
