document.addEventListener("turbo:load", () => {
  const friendsSearch = document.querySelector('.friends-search');
  const friendCard = document.querySelectorAll('.friends__card');

  if (friendsSearch !== null) {
    const userId = friendsSearch.dataset.userId;
    let friends;
  
    // Fetch all the user's friends and store them in a variable
    fetch(`/users/${userId}/friends`, {
      headers: {
        'Accept': 'application/json'
      }
    })
      .then(response => response.json())
      .then(data => {
        friends = data;
      })
      .catch(error => {
        console.error(error);
      });
  
    // If the user's input is included in a friend's name, display their card else hide it
    friendsSearch.addEventListener('input', event => {
      const value = event.target.value.toLowerCase();
      for (let i = 0; i < friends.length; i++) {
        if (friends[i].name.toLowerCase().includes(value)) {
          friendCard[i].style.display = 'flex';
        } else {
          friendCard[i].style.display = 'none';
        }
      }
    });
  }
});
