const questions = [
  {
    question: "What is the value of x if 2x + 3 = 9?",
    options: ["2", "3", "4", "6"],
    answer: 1, // Index of the correct answer
  },
  {
    question: "If a rectangle has a length of 5 and width of 3, what is the area?",
    options: ["8", "15", "10", "12"],
    answer: 1,
  },
  {
    question: "Simplify: (2 + 3)² - 4",
    options: ["21", "23", "25", "27"],
    answer: 2,
  },
  // Add more questions as needed
];

let currentQuestionIndex = 0;
let answers = Array(questions.length).fill(null);
let timer = 35 * 60; // 35 minutes in seconds

// Load initial question
function loadQuestion(index) {
  const container = document.getElementById("question-container");
  container.innerHTML = `
    <div class="question active">
      <p><strong>Question ${index + 1}:</strong> ${questions[index].question}</p>
      ${questions[index].options
        .map(
          (option, i) => `
        <label>
          <input type="radio" name="answer" value="${i}" ${answers[index] === i ? "checked" : ""}>
          ${option}
        </label>
      `
        )
        .join("")}
    </div>
  `;
  updateButtons();
}

// Update buttons based on question index
function updateButtons() {
  document.getElementById("prev-btn").disabled = currentQuestionIndex === 0;
  const nextBtn = document.getElementById("next-btn");
  const submitBtn = document.getElementById("submit-btn");

  if (currentQuestionIndex === questions.length - 1) {
    nextBtn.style.display = "none";
    submitBtn.style.display = "inline-block";
  } else {
    nextBtn.style.display = "inline-block";
    submitBtn.style.display = "none";
  }
}

// Save answer
function saveAnswer() {
  const selectedOption = document.querySelector("input[name='answer']:checked");
  if (selectedOption) {
    answers[currentQuestionIndex] = parseInt(selectedOption.value, 10);
  }
}

// Timer function
function startTimer() {
  const timerDisplay = document.getElementById("timer");
  const interval = setInterval(() => {
    if (timer <= 0) {
      clearInterval(interval);
      alert("Time is up! Submitting your answers.");
      submitTest();
    } else {
      const minutes = Math.floor(timer / 60);
      const seconds = timer % 60;
      timerDisplay.textContent = `${minutes}:${seconds < 10 ? "0" : ""}${seconds}`;
      timer--;
    }
  }, 1000);
}

// Submit test
function submitTest() {
  let score = 0;
  questions.forEach((q, i) => {
    if (answers[i] === q.answer) score++;
  });
  alert(`You scored ${score} out of ${questions.length}`);
}

// Event Listeners
document.getElementById("prev-btn").addEventListener("click", () => {
  saveAnswer();
  currentQuestionIndex--;
  loadQuestion(currentQuestionIndex);
});

document.getElementById("next-btn").addEventListener("click", () => {
  saveAnswer();
  currentQuestionIndex++;
  loadQuestion(currentQuestionIndex);
});

document.getElementById("submit-btn").addEventListener("click", () => {
  saveAnswer();
  submitTest();
});

// Initialize
loadQuestion(currentQuestionIndex);
startTimer();
