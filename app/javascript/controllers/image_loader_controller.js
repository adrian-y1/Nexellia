import { Controller } from '@hotwired/stimulus';

export default class extends Controller {

  static targets = [ "image" ]

  connect() {
    this.imageTarget.addEventListener("error", this.handleError)  
  }
  
  handleError = () => {
    let placeholder_image = new Image()
    placeholder_image.src = "https://archive.org/download/placeholder-image/placeholder-image.jpg" 

    // Copy attributes from original image to the placeholder image
    placeholder_image = this.copyAttributes(placeholder_image, this.imageTarget)

    // Replace original with placeholder_image
    this.imageTarget.parentNode.replaceChild(placeholder_image, this.imageTarget)
    
    let retries = 0
    const reloadImage = () => {
      retries++
      if(retries < 3) {
        setTimeout(() => {
          this.imageTarget.src = this.imageTarget.src
          reloadImage() 
        }, 2000)
      }
    }

    this.replaceImage(placeholder_image)
    
    reloadImage()
  }

  copyAttributes(placeholder_image, originalImage) {
    placeholder_image.width = originalImage.width
    placeholder_image.style.maxHeight = "600px"
    placeholder_image.setAttribute("data-picture-modal-target", "postShowPicture")
    placeholder_image.setAttribute("data-modal-target", "modal")
    return placeholder_image
  }

  replaceImage(placeholder_image) {
    this.imageTarget.onload = () => {
      if (placeholder_image.parentNode !== null) {
        placeholder_image.parentNode.replaceChild(this.imageTarget, placeholder_image)
      }
    }
  }
}