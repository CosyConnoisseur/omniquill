// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"



Turbo.config.drive.transition = true


//Adding mobile style swiping page transitions


document.addEventListener("turbo:click", (event) => {
  const isBack = event.target.closest('[data-direction="back"]');
  if (isBack) {
    window.forcedTurboDirection = "back";
  }
});


document.addEventListener("turbo:visit", () => {
  if (window.forcedTurboDirection) {
    document.documentElement.dataset.turboVisitDirection = window.forcedTurboDirection;
    window.forcedTurboDirection = null;
  }
});
