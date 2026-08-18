// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"







//Adding mobile style swiping page transitions

let currentHistoryIndex = window.history.state?.turbo?.restorationIndex || 0;

document.addEventListener("turbo:before-visit", (event) => {
  const currentPath = window.location.pathname;
  const destinationPath = new URL(event.detail.url).pathname;

  const clickedElement = document.activeElement;
  const isBackElement = clickedElement?.closest('[data-direction="back"]');

  if (isBackElement || (destinationPath === "/" && currentPath !== "/")) {
    setBackTransition();
  }

  else if (destinationPath === currentPath) {
    clearTransitions();
  }
  else {
    setForwardTransition();
  }
});


window.addEventListener("popstate", () => {
  let nextHistoryIndex = currentHistoryIndex-1

  if (nextHistoryIndex < currentHistoryIndex) {
    setBackTransition();
  }
  else {
    setForwardTransition();
  }
});

function setForwardTransition() {
  document.documentElement.classList.add("transition-forward");
  document.documentElement.classList.remove("transition-back");
}

function setBackTransition() {
  document.documentElement.classList.add("transition-back");
  document.documentElement.classList.remove("transition-forward");
}

function clearTransitions() {
  document.documentElement.classList.remove("transition-back", "transition-forward");
}
