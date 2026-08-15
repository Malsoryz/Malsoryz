import Alpine from "alpinejs";

window.Alpine = Alpine;

document.addEventListener("alpine:init", () => {
  Alpine.data("typewriter", ({ interval = 2000 }) => ({
    texts: [],
    currentIndex: 0,
    text: "",
    interval,
    isDeleting: false,

    init() {
      this.texts = this.$el.dataset.texts.split("|").map((text) => text.trim());

      this.tick();
    },

    tick() {
      var i = this.currentIndex % this.texts.length;
      var fullText = this.texts[i];

      if (this.isDeleting) {
        this.text = fullText.slice(0, this.text.length - 1);
      } else {
        this.text = fullText.slice(0, this.text.length + 1);
      }

      var delta = 200 - Math.random() * 100;

      if (this.isDeleting) {
        delta /= 2;
      }

      if (!this.isDeleting && this.text === fullText) {
        delta = this.interval;
        this.isDeleting = true;
      } else if (this.isDeleting && this.text === "") {
        this.isDeleting = false;
        this.currentIndex++;
        delta = 500;
      }

      setTimeout(() => {
        this.tick();
      }, delta);
    },
  }));
});

Alpine.start();
