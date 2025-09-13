import pygame
import math
from arrow import Arrow

class Bow:
    def __init__(self, x, y, image):
        self.x = x
        self.y = y
        self.angle = 0
        self.original_image = image
        self.image = self.original_image.copy()

    def update_angle(self, mouse_pos):
        dx = mouse_pos[0] - self.x
        dy = mouse_pos[1] - self.y
        self.angle = math.atan2(dy, dx)

    def draw(self, screen):
        # Rotate the bow image
        rotated_image = pygame.transform.rotate(self.original_image, -math.degrees(self.angle))
        rect = rotated_image.get_rect(center=(self.x, self.y))
        screen.blit(rotated_image, rect.topleft)

    def shoot_arrow(self, arrow_image):
        return Arrow(self.x, self.y, self.angle, arrow_image)
