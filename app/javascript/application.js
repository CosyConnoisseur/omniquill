// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"







//Adding mobile style swiping page transitions

let currentHistoryIndex = window.history.state?.turbo?.restorationIndex || 0;

document.addEventListener("turbo:before-visit", (event) => {
  const currentPath = window.location.pathname;
  const destinationUrl = new URL(event.detail.url);
  const destinationPath = destinationUrl.pathname;

  if (destinationPath === currentPath) {
    // event.preventDefault();
    clearTransitions();
    return
  }


  const clickedElement = document.activeElement;
  const isBackElement = clickedElement?.closest('[data-direction="back"]');

  if (isBackElement || (destinationPath === "/" && currentPath !== "/")) {
    setBackTransition();
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


// Manually register the PWA service worker
if ("serviceWorker" in navigator) {
  window.addEventListener("load", () => {
    navigator.serviceWorker.register("/serviceworker.js");
  });
}

// Force Turbo to wait for your mobile slide animations to complete
document.addEventListener("turbo:before-render", (event) => {
  if (document.startViewTransition) {
    event.preventDefault(); // Stop Turbo from rendering instantly

    document.startViewTransition(() => {
      event.detail.resume(); // Render the new page inside the native transition
    });
  }
});

Turbo.config.drive.transition = true
