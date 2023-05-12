# Super Mario Bros intro notes
$notes = @(659, 659, 0, 659, 0, 523, 659, 0, 784, 0, 392, 0, 523, 0, 392, 0, 330, 0, 440, 0, 494, 0, 466, 0, 440, 659, 0, 784, 0, 880, 0, 698, 0, 784, 0, 659, 0, 523, 0, 587, 0, 494, 0, 523, 0, 392, 0, 330, 0, 440, 0, 494, 0, 466, 0, 440, 659, 0, 784, 0, 880, 0, 698, 0, 784, 0, 659, 0, 523, 0, 587, 0, 494, 0, 523, 0, 392, 0, 330, 0, 440, 0, 494, 0, 466, 0, 440)

# Set the beep duration in milliseconds
$duration = 200

# Loop through the notes and play them using the console beep
foreach ($note in $notes) {
    if ($note -eq 0) {
        # Add a pause between notes
        Start-Sleep -Milliseconds ($duration * 1.5)
    } else {
        # Play the note using the console beep
        [Console]::Beep($note, $duration)
    }
}
