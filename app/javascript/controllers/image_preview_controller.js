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

    files.forEach((file, index) => {
      const reader = new FileReader()

      reader.onload = (event) => {
        const container = document.createElement("div")
        container.classList.add("trip-photo-item")

        const image = document.createElement("img")
        image.src = event.target.result
        image.alt = "追加する写真"
        image.classList.add("trip-photo")

        const deleteButton = document.createElement("button")
        deleteButton.type = "button"
        deleteButton.textContent = "× 削除"
        deleteButton.classList.add("photo-delete-button")

        deleteButton.addEventListener("click", () => {
          this.removeFile(index)
        })

        container.appendChild(image)
        container.appendChild(deleteButton)
        this.previewTarget.appendChild(container)
      }

      reader.readAsDataURL(file)
    })
  }

  removeFile(index) {
    const dataTransfer = new DataTransfer()
    const files = Array.from(this.inputTarget.files)

    files.forEach((file, fileIndex) => {
      if (fileIndex !== index) {
        dataTransfer.items.add(file)
      }
    })

    this.inputTarget.files = dataTransfer.files
    this.preview()
  }
}