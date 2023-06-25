import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['postShowPicture'];

  showModal() {
    // Create the modal and close button elements
    const image = this.postShowPictureTarget;
    const modalElement = document.createElement('div');
    const closeButton = document.createElement('button');

    // Add the necessary attributes for the modal element
    modalElement.classList.add('modal');
    modalElement.id = 'post-picture-modal';
    modalElement.setAttribute('data-controller', 'modal');
    modalElement.setAttribute('data-modal-target', 'modal');

    // Add the necessary attributes for the close button element
    closeButton.classList.add('modal__header--close');
    closeButton.setAttribute('data-action', 'click->modal#close');
    closeButton.innerHTML = '<i class="bi bi-x"></i>';

    // Append the image and the close button to the modal element
    modalElement.appendChild(closeButton);
    modalElement.appendChild(image.cloneNode(true));
    
    // Append the modal element to the document body
    const bodyElement = document.querySelector('.body-element');
    bodyElement.appendChild(modalElement);
  }
}
