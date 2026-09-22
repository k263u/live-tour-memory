import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["cost", "total"]

  connect() {
    this.calculate()
  }

  calculate() {
    const total = this.costTargets.reduce((sum, input) => {
      return sum + (parseInt(input.value, 10) || 0)
    }, 0)

    this.totalTarget.textContent = `${total.toLocaleString()}円`
  }
}