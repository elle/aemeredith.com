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

  function initElleBread() {
    var form = document.querySelector(".order-form");
    if (!form) return;

    var PHONE_LENGTH = 10;
    var rows = Array.prototype.slice.call(form.querySelectorAll(".bread-row"));
    var totalEl = form.querySelector(".order-total__amount");
    var errorEl = form.querySelector(".order-form__error");
    var nameInput = form.querySelector('input[name="name"]');
    var phoneInput = form.querySelector('input[name="phone"]');

    // Show errors once a field has been left or the form has been submitted,
    // or immediately when the server rendered an error we are correcting.
    var touched = errorEl.textContent.trim() !== "";

    function qtyOf(row) {
      return parseInt(row.querySelector('input[type="hidden"]').value, 10) || 0;
    }

    function hasItems() {
      return rows.some(function (row) {
        return qtyOf(row) > 0;
      });
    }

    function updateTotal() {
      var total = 0;
      rows.forEach(function (row) {
        total += qtyOf(row) * (parseFloat(row.getAttribute("data-price")) || 0);
      });
      totalEl.textContent = "$" + total.toFixed(2);
    }

    function errors() {
      var messages = [];
      if (!hasItems()) {
        messages.push("Please choose at least one loaf.");
      }
      if (nameInput.value.trim() === "") {
        messages.push("Please enter your name.");
      }
      if (phoneInput.value.replace(/\D/g, "").length !== PHONE_LENGTH) {
        messages.push("Please enter a 10-digit phone number.");
      }
      return messages;
    }

    function showErrors() {
      errorEl.textContent = errors().join(" ");
    }

    function update() {
      updateTotal();
      if (touched) {
        showErrors();
      }
    }

    rows.forEach(function (row) {
      var hidden = row.querySelector('input[type="hidden"]');
      var qtyEl = row.querySelector(".stepper__qty");
      row.querySelectorAll(".stepper__btn").forEach(function (btn) {
        btn.addEventListener("click", function () {
          var step = parseInt(btn.getAttribute("data-step"), 10);
          var next = Math.max(0, qtyOf(row) + step);
          hidden.value = next;
          qtyEl.textContent = next;
          update();
        });
      });
    });

    [nameInput, phoneInput].forEach(function (input) {
      function validateField() {
        touched = true;
        update();
      }
      input.addEventListener("input", validateField);
      input.addEventListener("blur", validateField);
    });

    form.addEventListener("submit", function (event) {
      touched = true;
      if (errors().length > 0) {
        event.preventDefault();
        showErrors();
      }
    });

    updateTotal();
  }

  function initWeeklySelection() {
    var form = document.querySelector(".weekly-form");
    if (!form) return;

    var MAX = 3;
    var checkboxes = Array.prototype.slice.call(
      form.querySelectorAll('input[type="checkbox"]')
    );
    var hint = form.querySelector(".weekly-form__hint");

    function refresh() {
      var count = checkboxes.filter(function (box) {
        return box.checked;
      }).length;
      hint.textContent = count + " of " + MAX + " selected";
      checkboxes.forEach(function (box) {
        box.disabled = !box.checked && count >= MAX;
      });
    }

    checkboxes.forEach(function (box) {
      box.addEventListener("change", refresh);
    });
    refresh();
  }

  initTestimonials();
  initTalks();
  initElleBread();
  initWeeklySelection();
})();
