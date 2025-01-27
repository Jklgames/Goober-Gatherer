extends Node3D
class_name  Bar

@export var progressBar : ProgressBar
@export var value : float
@export var shouldLerp : bool = true #false makes value be set instantly
@export var timedLerp : bool = true #false makes lerps at a constant speed for as long as needed
@export var lerpRate : float
@export var timeToLerp : float #seconds

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func SetMax(maxValue : float):
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
	if abs(diff) < 0.001:
		progressBar.value = value
		return

	if timedLerp:
		progressBar.value = lerp(progressBar.value, value, delta/timeToLerp)
	else:
		progressBar.value = lerp(progressBar.value, value, lerpRate)
	pass
