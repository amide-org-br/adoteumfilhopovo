// Vanilla JS theme interactions (no jQuery)
// Requires Bootstrap 5 to be available as window.bootstrap (set in app/javascript/application.js)

document.addEventListener("turbo:load", () => {
  // Smooth scrolling for in-page anchors
  const smoothSelectors = ".nav-link, .nav-btn, .custom-btn-link";
  document.querySelectorAll(smoothSelectors).forEach((link) => {
    link.addEventListener("click", (event) => {
      const href = link.getAttribute("href");
      if (!href || href.startsWith("http") || href.startsWith("mailto:") || href === "#") {
        return; // allow default behavior for external links or placeholders
      }
      const target = document.querySelector(href);
      if (target) {
        event.preventDefault();
        const y = target.getBoundingClientRect().top + window.pageYOffset - 80;
        window.scrollTo({ top: y, behavior: "smooth" });
      }
    });
  });

  // Scroll to top for .home-link
  document.querySelectorAll(".home-link").forEach((link) => {
    link.addEventListener("click", (event) => {
      event.preventDefault();
      window.scrollTo({ top: 0, behavior: "smooth" });
    });
  });

  // Initialize Bootstrap tooltips and popovers
  if (window.bootstrap) {
    const tooltipTriggers = Array.from(
      document.querySelectorAll('[data-bs-toggle="tooltip"], [data-toggle="tooltip"]')
    );
    tooltipTriggers.forEach((el) => new window.bootstrap.Tooltip(el));

    const popoverTriggers = Array.from(
      document.querySelectorAll('[data-bs-toggle="popover"], [data-toggle="popover"]')
    );
    popoverTriggers.forEach((el) => new window.bootstrap.Popover(el));
  }
});