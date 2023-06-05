import { Controller } from '@hotwired/stimulus';

export default class extends Controller {

  // Starts off with darkmode if it was enabled before
  connect() {
    this.initializeDarkMode();
  }

  // Toggles the theme. If darkmode is enabled, disable it, else enable it
  toggleTheme() {
    if (this.darkModeEnabled()) {
      this.disableDarkMode();
    } else {
      this.enableDarkMode();
    }
  }

  // Enables darkmode and sets it's localStorage value to 'enabled'
  enableDarkMode() {
    document.body.classList.add('darkmode');
    localStorage.setItem('darkMode', 'enabled');
    const themeIcon = this.element.querySelector('i')
    this.changeThemeIcon('fa-sun', 'fa-moon')
  }

  // Disables darkmode and sets it's localStorage value to null
  disableDarkMode() {
    document.body.classList.remove('darkmode');
    localStorage.setItem('darkMode', null);
    this.changeThemeIcon('fa-moon', 'fa-sun')
  }

  // Checks if darkmode is enabled or not
  darkModeEnabled() {
    return localStorage.getItem('darkMode') === 'enabled';
  }

  // If darkmode has already been enabled before, keep it enabled 
  initializeDarkMode() {
    if (this.darkModeEnabled()) {
      this.enableDarkMode();
    }
  }

  // Changes the icon of the i tag depending on the theme
  changeThemeIcon(prevClass, newClass) {
    const themeIcon = this.element.querySelector('i')
    themeIcon.classList.remove(prevClass)
    themeIcon.classList.add(newClass)
  }
}
