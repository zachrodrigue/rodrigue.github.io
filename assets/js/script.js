'use strict';

/**
 * element toggle function
 */
const elemToggleFunc = function (elem) {
  elem.classList.toggle("active");
};

/**
 * header sticky & go to top
 */
const header = document.querySelector("[data-header]");
const goTopBtn = document.querySelector("[data-go-top]");

window.addEventListener("scroll", function () {
  if (window.scrollY >= 10) {
    header.classList.add("active");
    goTopBtn.classList.add("active");
  } else {
    header.classList.remove("active");
    goTopBtn.classList.remove("active");
  }
});

/**
 * navbar toggle
 */
const navToggleBtn = document.querySelector("[data-nav-toggle-btn]");
const navbar = document.querySelector("[data-navbar]");

navToggleBtn.addEventListener("click", function () {
  elemToggleFunc(navToggleBtn);
  elemToggleFunc(navbar);
  elemToggleFunc(document.body);
});

/**
 * skills toggle
 */
const toggleBtnBox = document.querySelector("[data-toggle-box]");
const toggleBtns = document.querySelectorAll("[data-toggle-btn]");
const skillsBox = document.querySelector("[data-skills-box]");

for (let i = 0; i < toggleBtns.length; i++) {
  toggleBtns[i].addEventListener("click", function () {
    elemToggleFunc(toggleBtnBox);
    for (let i = 0; i < toggleBtns.length; i++) {
      elemToggleFunc(toggleBtns[i]);
    }
    elemToggleFunc(skillsBox);
  });
}

/**
 * dark & light theme toggle
 */
const themeToggleBtn = document.querySelector("[data-theme-btn]");

themeToggleBtn.addEventListener("click", function () {
  elemToggleFunc(themeToggleBtn);

  if (themeToggleBtn.classList.contains("active")) {
    document.body.classList.remove("dark_theme");
    document.body.classList.add("light_theme");
    localStorage.setItem("theme", "light_theme");
  } else {
    document.body.classList.add("dark_theme");
    document.body.classList.remove("light_theme");
    localStorage.setItem("theme", "dark_theme");
  }
});

/**
 * check & apply last time selected theme from localStorage
 */
if (localStorage.getItem("theme") === "light_theme") {
  themeToggleBtn.classList.add("active");
  document.body.classList.remove("dark_theme");
  document.body.classList.add("light_theme");
} else {
  themeToggleBtn.classList.remove("active");
  document.body.classList.remove("light_theme");
  document.body.classList.add("dark_theme");
}

/**
 * Language Toggle Functionality
 */
const languageToggle = document.getElementById('lang');

// Function to switch language
function switchLanguage(lang) {
  // Hide all elements with data-lang attribute
  document.querySelectorAll('[data-lang]').forEach(element => {
    element.style.display = 'none';
  });

  // Show elements for the selected language
  document.querySelectorAll(`[data-lang="${lang}"]`).forEach(element => {
    element.style.display = 'block'; // or 'inline', 'inline-block', etc., depending on the element
  });

  // Save the selected language to localStorage
  localStorage.setItem('language', lang);
}

// Event listener for language toggle
languageToggle.addEventListener('change', (event) => {
  const selectedLang = event.target.value;
  switchLanguage(selectedLang);
});

// Set default language on page load
document.addEventListener('DOMContentLoaded', () => {
  const defaultLang = localStorage.getItem('language') || 'en'; // Default language is 'en'
  switchLanguage(defaultLang);
  languageToggle.value = defaultLang; // Set the toggle to the default language
});

const navToggleBtn = document.querySelector("[data-nav-toggle-btn]");
const navbar = document.querySelector("[data-navbar]");

navToggleBtn.addEventListener("click", function () {
  navbar.classList.toggle("active");
  navToggleBtn.classList.toggle("active");
});

// Close the menu when a link is clicked
const navbarLinks = document.querySelectorAll(".navbar-link");
navbarLinks.forEach((link) => {
  link.addEventListener("click", function () {
    navbar.classList.remove("active");
    navToggleBtn.classList.remove("active");
  });
});
