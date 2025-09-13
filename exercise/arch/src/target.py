import pygame

class Target:
    def __init__(self, x, y, radius=50):
        self.x = x
        self.y = y
        self.radius = radius
        self.colors = [(255, 0, 0), (255, 255, 0), (0, 0, 255), (0, 0, 0)]

    def draw(self, screen):
        for i in range(4):
            current_radius = self.radius * (4 - i) / 4
            pygame.draw.circle(screen, self.colors[i], (self.x, self.y), int(current_radius))

    def check_hit(self, arrow):
        distance = ((arrow.x - self.x) ** 2 + (arrow.y - self.y) ** 2) ** 0.5
        return distance < self.radius
