let totalScore = 0;
let shotsMade = 0;
let shotsLeft = 5;
let isGameActive = false;
let rotationInterval;

// Start the game
document.getElementById('start-btn').addEventListener('click', () => {
    isGameActive = true;
    shotsMade = 0;
    shotsLeft = 5;
    totalScore = 0;

    document.getElementById('start-btn').style.display = 'none'; // Hide start button
    document.getElementById('rotate-again-btn').style.display = 'block'; // Show rotate again button
    document.getElementById('reset-btn').style.display = 'block'; // Show reset button

    updateScoreboard();
    startWheelRotation(); // Start rotating the wheel
});

// Start rotating the wheel at 180 RPM (3 rotations per second)
function startWheelRotation() {
    const wheel = document.getElementById('wheel');
    wheel.style.transition = 'transform 1s ease-out'; // Smooth transition for rotation
    const randomRotation = Math.floor(Math.random() * 360) + 720; // Rotate at least 720 degrees
    wheel.style.transform = `rotate(${randomRotation}deg)`;

    // Rotate at 180 RPM (180 degrees per second)
    rotationInterval = setInterval(() => {
        const currentRotation = getWheelRotation();
        wheel.style.transform = `rotate(${currentRotation + 3}deg)`; // Rotate slightly
    }, 1000 / 60); // 60 FPS
}

// Stop the wheel and calculate points
function stopWheelRotation() {
    clearInterval(rotationInterval);
    const wheel = document.getElementById('wheel');
    wheel.style.transition = 'transform 0s'; // Stop immediately

    const currentRotation = getWheelRotation();
    const pointsForSegment = calculatePoints(currentRotation); // Calculate points based on segment
    totalScore += pointsForSegment; // Update total score

    // Update shots made and shots left
    shotsMade++;
    shotsLeft--;

    // Update the display
    updateScoreboard();

    // Show points scored for this shot
    alert(`You scored: ${pointsForSegment} points!`);

    // Check if game is over
    if (shotsLeft === 0) {
        isGameActive = false; // Set game state to inactive
        alert(`Game Over! Your total score is ${totalScore}.`);
        document.getElementById('rotate-again-btn').style.display = 'none'; // Hide rotate again button
        document.getElementById('start-btn').style.display = 'block'; // Show start button
    }
}

// Calculate points based on the current rotation angle
function calculatePoints(currentRotation) {
    const segmentSize = 360 / 5; // Each segment occupies 72 degrees
    const index = Math.floor(((currentRotation % 360) + (segmentSize / 2)) / segmentSize); // Get the segment index
    return index + 1; // Points are from 1 to 5
}

// Get the current rotation of the wheel
function getWheelRotation() {
    const wheel = document.getElementById('wheel');
    const transformMatrix = window.getComputedStyle(wheel).getPropertyValue('transform');
    const matrixValues = transformMatrix.match(/matrix\((.*)\)/)[1].split(', ');
    const a = matrixValues[0];
    const b = matrixValues[1];
    let angle = Math.atan2(b, a) * (180 / Math.PI);
    if (angle < 0) angle += 360;
    return angle;
}

// Update the scoreboard
function updateScoreboard() {
    document.getElementById('shots-made').textContent = shotsMade;
    document.getElementById('shots-left').textContent = shotsLeft;
    document.getElementById('points-scored').textContent = (shotsMade > 0) ? (totalScore - (totalScore - (totalScore / shotsMade))) : 0; // Points of last shot
    document.getElementById('total-score').textContent = totalScore;
}

// Event listener for clicking on the wheel
document.getElementById('wheel').addEventListener('click', () => {
    if (isGameActive) {
        stopWheelRotation(); // Stop wheel rotation and calculate points
    }
});

// Event listener for the "Rotate Again" button
document.getElementById('rotate-again-btn').addEventListener('click', () => {
    if (isGameActive && shotsLeft > 0) {
        startWheelRotation(); // Start rotating the wheel again
    }
});

// Event listener for the "Reset" button
document.getElementById('reset-btn').addEventListener('click', () => {
    totalScore = 0;
    shotsMade = 0;
    shotsLeft = 5;
    isGameActive = false;

    document.getElementById('start-btn').style.display = 'block'; // Show start button
    document.getElementById('rotate-again-btn').style.display = 'none'; // Hide rotate again button
    document.getElementById('reset-btn').style.display = 'none'; // Hide reset button

    // Reset scoreboard
    updateScoreboard();
});
