(function () {
  "use strict";

  function initTestimonials() {
    var root = document.querySelector(".testimonials");
    if (!root) return;

    var slides = Array.prototype.slice.call(
      root.querySelectorAll(".testimonials__quote")
    );
    var cite = root.querySelector(".testimonials__cite");
    var counter = root.querySelector(".testimonials__counter");
    var prev = root.querySelector(".testimonials__btn--prev");
    var next = root.querySelector(".testimonials__btn--next");
    if (slides.length < 2) return;

    var index = 0;
    var paused = false;
    var touchStartX = null;
    var AUTO_ADVANCE_MS = 6000;
    var SWIPE_THRESHOLD = 50;

    function pad(n) {
      return n < 10 ? "0" + n : String(n);
    }

    function show(nextIndex) {
      index = (nextIndex + slides.length) % slides.length;
      slides.forEach(function (slide, i) {
        slide.classList.toggle("is-active", i === index);
      });
      cite.textContent = slides[index].getAttribute("data-author");
      counter.textContent = pad(index + 1) + " / " + pad(slides.length);
    }

    prev.addEventListener("click", function () {
      show(index - 1);
    });
    next.addEventListener("click", function () {
      show(index + 1);
    });

    root.addEventListener("keydown", function (event) {
      if (event.key === "ArrowLeft") show(index - 1);
      if (event.key === "ArrowRight") show(index + 1);
    });

    ["mouseenter", "focusin", "touchstart"].forEach(function (type) {
      root.addEventListener(type, function () {
        paused = true;
      });
    });
    ["mouseleave", "focusout"].forEach(function (type) {
      root.addEventListener(type, function () {
        paused = false;
      });
    });

    root.addEventListener("touchstart", function (event) {
      touchStartX = event.touches[0].clientX;
    });
    root.addEventListener("touchend", function (event) {
      if (touchStartX === null) return;
      var dx = event.changedTouches[0].clientX - touchStartX;
      if (Math.abs(dx) > SWIPE_THRESHOLD) show(index + (dx < 0 ? 1 : -1));
      touchStartX = null;
      paused = false;
    });

    setInterval(function () {
      if (!paused) show(index + 1);
    }, AUTO_ADVANCE_MS);
  }

  function initTalks() {
    var list = document.querySelector(".talks__list");
    var toggle = document.querySelector(".talks__toggle");
    if (!list || !toggle) return;

    var collapseCount = parseInt(list.getAttribute("data-collapse"), 10) || 8;
    var total = list.querySelectorAll(".talks__item").length;
    if (total <= collapseCount) return;

    var collapsed = true;

    function render() {
      list.classList.toggle("is-collapsed", collapsed);
      toggle.textContent = collapsed
        ? "Show all " + total + " talks"
        : "Show fewer talks";
    }

    toggle.hidden = false;
    render();

    toggle.addEventListener("click", function () {
      collapsed = !collapsed;
      render();
    });
  }

  initTestimonials();
  initTalks();
})();
