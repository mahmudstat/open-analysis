import pygame
from bow import Bow
from target import Target
from arrow import Arrow
from score_manager import ScoreManager

class Game:
    def __init__(self):
        self.screen = pygame.display.set_mode((800, 600))
        pygame.display.set_caption("Archery Game")
        self.clock = pygame.time.Clock()
        self.bow = Bow(100, 300)
        self.target = Target(600, 300)
        self.arrows = []
        self.score_manager = ScoreManager()
        self.background = pygame.Surface((800, 600))
        self.background.fill((255, 255, 255))  # White background

    def handle_events(self):
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                return False
            elif event.type == pygame.MOUSEBUTTONDOWN:
                if event.button == 1:  # Left click
                    new_arrow = self.bow.shoot_arrow()
                    self.arrows.append(new_arrow)
        return True

    def update(self):
        mouse_pos = pygame.mouse.get_pos()
        self.bow.update_angle(mouse_pos)

        # Update arrows
        for arrow in self.arrows[:]:
            arrow.update()
            if self.target.check_hit(arrow):
                self.score_manager.add_score(10)
                self.arrows.remove(arrow)
            elif arrow.is_off_screen(800, 600):
                self.arrows.remove(arrow)

    def draw(self):
        self.screen.blit(self.background, (0, 0))
        self.target.draw(self.screen)
        self.bow.draw(self.screen)
        for arrow in self.arrows:
            arrow.draw(self.screen)

        # Draw score
        font = pygame.font.Font(None, 36)
        score_text = font.render(f"Score: {self.score_manager.get_score()}", True, (0, 0, 0))
        self.screen.blit(score_text, (20, 20))

        pygame.display.flip()

    def run(self):
        running = True
        while running:
            running = self.handle_events()
            self.update()
            self.draw()
            self.clock.tick(60)
