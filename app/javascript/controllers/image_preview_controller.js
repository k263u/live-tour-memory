import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["preview", "input", "label"]

  preview() {
    this.previewTarget.innerHTML = ""

    const files = Array.from(this.inputTarget.files)

    if (files.length === 0) {
      this.labelTarget.hidden = true
      return
    }

    this.labelTarget.hidden = false

    files.forEach((file) => {
      const reader = new FileReader()

      reader.onload = (event) => {
        const image = document.createElement("img")
        image.src = event.target.result
        image.alt = "追加する写真"
        image.classList.add("trip-photo")

        this.previewTarget.appendChild(image)
      }

      reader.readAsDataURL(file)
    })
  }
}