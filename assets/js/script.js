"use strict";

/**
 * Element toggle function
 */
const elemToggleFunc = function (elem) {
  elem.classList.toggle("active");
};

/**
 * Header sticky & go to top
 */
const header = document.querySelector("[data-header]");
const goTopBtn = document.querySelector("[data-go-top]");

window.addEventListener("scroll", function () {
  const isScrolled = window.scrollY >= 10;
  header.classList.toggle("active", isScrolled);
  goTopBtn.classList.toggle("active", isScrolled);
});

/**
 * Navbar toggle
 */
const navToggleBtn = document.querySelector("[data-nav-toggle-btn]");
const navbar = document.querySelector("[data-navbar]");

navToggleBtn.addEventListener("click", function () {
  elemToggleFunc(navToggleBtn);
  elemToggleFunc(navbar);
  elemToggleFunc(document.body);
});

// Close the menu when a link is clicked
navbar.addEventListener("click", function (event) {
  if (event.target.classList.contains("navbar-link")) {
    navbar.classList.remove("active");
    navToggleBtn.classList.remove("active");
  }
});

/**
 * Skills toggle
 */
const toggleBtnBox = document.querySelector("[data-toggle-box]");
const toggleBtns = document.querySelectorAll("[data-toggle-btn]");
const skillsBox = document.querySelector("[data-skills-box]");

toggleBtns.forEach((btn) => {
  btn.addEventListener("click", function () {
    [toggleBtnBox, ...toggleBtns, skillsBox].forEach(elemToggleFunc);
  });
});

/**
 * Dark & light theme toggle
 */
const themeToggleBtn = document.querySelector("[data-theme-btn]");

themeToggleBtn.addEventListener("click", function () {
  const isLightTheme = themeToggleBtn.classList.toggle("active");
  document.body.classList.toggle("light_theme", isLightTheme);
  document.body.classList.toggle("dark_theme", !isLightTheme);
  localStorage.setItem("theme", isLightTheme ? "light_theme" : "dark_theme");
});

/**
 * Check & apply last time selected theme from localStorage
 */
if (localStorage.getItem("theme") === "light_theme") {
  themeToggleBtn.classList.add("active");
  document.body.classList.add("light_theme");
} else {
  themeToggleBtn.classList.remove("active");
  document.body.classList.add("dark_theme");
}

/**
 * Language Toggle Functionality
 */
const languageToggle = document.getElementById("lang");

function switchLanguage(lang) {
  document.querySelectorAll("[data-lang]").forEach((element) => {
    element.style.display = element.dataset.lang === lang ? "block" : "none";
  });
  localStorage.setItem("language", lang);
}

languageToggle.addEventListener("change", (event) => {
  switchLanguage(event.target.value);
});

document.addEventListener("DOMContentLoaded", () => {
  const defaultLang = localStorage.getItem("language") || "en";
  switchLanguage(defaultLang);
  languageToggle.value = defaultLang;
});
