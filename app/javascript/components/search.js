document.addEventListener("turbo:load", () => {
  let users;

  // Fetch all users
  fetch('/users', {
    headers: {
      'Accept': 'application/json'
    }
  })
    .then(response => response.json())
    .then(data => {
      users = data;
    })
    .catch(error => {
      console.error(error);
    });

  const search = document.getElementById("search-users");
  const searchResults = document.querySelector(".search-results");

  if (searchResults !== null) {
    searchResults.style.display = "none";
  }

  // Listen for user input
  if (search !== null) {
    search.addEventListener("input", event => {
      const value = event.target.value.toLowerCase();
      searchResults.innerHTML = "";
  
      // If the user input is not empty and is included in the user's name, 
      // create card and append it
      if (value.trim() !== "") {
        let hasResults = false; // Flag to check if there are any search results
        users.forEach(user => {
          if (user.name.toLowerCase().includes(value)) {
            createCard(user, searchResults);
            hasResults = true;
          }
        });
  
        if (!hasResults) {
          searchResults.style.display = "none"; // Hide the search results container if no results found
        } else {
          searchResults.style.display = "flex"; // Show the search results container if there are results
        }
      } else {
        searchResults.style.display = "none"; // Hide the search results container if the input is empty
      }
    });
  }

  handleOutsideClick(searchResults);
});

// Create a card element for the user
function createCard(user, container) {
  const searchUserCard = document.createElement("div");
  searchUserCard.classList = "search-results__card";
  searchUserCard.innerHTML = `
    <a href="/users/${user.id}" class="search-results__card--link">
      <div class="search-results__card--picture">
        <img src="${user.picture}" alt="${user.name} picture" width="40" height="40">
      </div>
      <div class="search-results__card--name">
        ${user.name}
      </div>
    </a>
  `;
  container.appendChild(searchUserCard);
}

// Hide container if the user has clicked outside
function handleOutsideClick(container) {
  window.addEventListener('click', event => {
    if(event.target !== container){
      if (container !== null ) {
        container.style.display = 'none'
      }
    }
})
}
