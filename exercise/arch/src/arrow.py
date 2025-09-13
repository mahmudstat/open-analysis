import pygame
import math

class Arrow:
    def __init__(self, x, y, angle, image, speed=10):
        self.x = x
        self.y = y
        self.angle = angle
        self.speed = speed
        self.original_image = image
        self.image = pygame.transform.rotate(self.original_image, -math.degrees(angle))
        self.rect = self.image.get_rect(center=(x, y))

    def update(self):
        self.x += self.speed * math.cos(self.angle)
        self.y += self.speed * math.sin(self.angle)
        self.rect.center = (self.x, self.y)
        # Update rotation for drawing
        self.image = pygame.transform.rotate(self.original_image, -math.degrees(self.angle))
        self.rect = self.image.get_rect(center=(self.x, self.y))

    def draw(self, screen):
        screen.blit(self.image, self.rect.topleft)

    def is_off_screen(self, screen_width, screen_height):
        return (self.x < 0 or self.x > screen_width or
                self.y < 0 or self.y > screen_height)
