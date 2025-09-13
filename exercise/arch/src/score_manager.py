class ScoreManager:
    def __init__(self):
        self.score = 0
        self.high_score = 0
        self.load_high_score()

    def add_score(self, points):
        self.score += points
        if self.score > self.high_score:
            self.high_score = self.score
            self.save_high_score()

    def get_score(self):
        return self.score

    def save_high_score(self):
        with open("scores.txt", "w") as f:
            f.write(str(self.high_score))

    def load_high_score(self):
        try:
            with open("scores.txt", "r") as f:
                self.high_score = int(f.read().strip())
        except (FileNotFoundError, ValueError):
            self.high_score = 0
