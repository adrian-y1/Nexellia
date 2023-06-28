// Get all flash notifications
const flashNotifications = document.querySelectorAll('.flash-notification')

flashNotifications.forEach(flash => {
  const closeButton = flash.querySelector('.flash-notification--button')
  const notificationId = closeButton.dataset.notificationId
  const url = `/notifications/${notificationId}`
  const csrftoken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

  // When close button is clicked, send the request
  closeButton.onclick = () => {
    sendUpdateRequest(url, notificationId, csrftoken)
  }

  // When the animation finishes, send the request
  flash.addEventListener('animationend', () => {
    sendUpdateRequest(url, notificationId, csrftoken)
  })
})

function sendUpdateRequest(url, notificationId, csrftoken) {
  fetch(url, {
    method: "PATCH",
    body : JSON.stringify(notificationId),
    headers: {
      'X-CSRF-Token': csrftoken
    }
  })
}
