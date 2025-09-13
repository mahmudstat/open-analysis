const canvas = document.getElementById('canvas');
const ctx = canvas.getContext('2d');
let isDrawing = false;
let lastX = 0;
let lastY = 0;
let currentTool = 'pencil';
let currentColor = '#000000';
let brushSize = 5;

// Initialize canvas
ctx.fillStyle = 'white';
ctx.fillRect(0, 0, canvas.width, canvas.height);
ctx.lineCap = 'round';

// Tool selection
document.getElementById('pencil').addEventListener('click', () => currentTool = 'pencil');
document.getElementById('eraser').addEventListener('click', () => currentTool = 'eraser');
document.getElementById('colorPicker').addEventListener('input', (e) => currentColor = e.target.value);
document.getElementById('brushSize').addEventListener('input', (e) => brushSize = e.target.value);
document.getElementById('clear').addEventListener('click', clearCanvas);
document.getElementById('save').addEventListener('click', saveDrawing);

// Drawing functions
canvas.addEventListener('mousedown', startDrawing);
canvas.addEventListener('mousemove', draw);
canvas.addEventListener('mouseup', stopDrawing);
canvas.addEventListener('mouseout', stopDrawing);

function startDrawing(e) {
    isDrawing = true;
    [lastX, lastY] = [e.offsetX, e.offsetY];
}

function draw(e) {
    if (!isDrawing) return;

    ctx.beginPath();
    ctx.moveTo(lastX, lastY);
    ctx.lineTo(e.offsetX, e.offsetY);

    if (currentTool === 'pencil') {
        ctx.strokeStyle = currentColor;
    } else if (currentTool === 'eraser') {
        ctx.strokeStyle = 'white';
    }

    ctx.lineWidth = brushSize;
    ctx.stroke();

    [lastX, lastY] = [e.offsetX, e.offsetY];
}

function stopDrawing() {
    isDrawing = false;
}

function clearCanvas() {
    ctx.fillStyle = 'white';
    ctx.fillRect(0, 0, canvas.width, canvas.height);
}

function saveDrawing() {
    const link = document.createElement('a');
    link.download = 'drawing.png';
    link.href = canvas.toDataURL();
    link.click();
}
