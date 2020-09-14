const collaspeInfoForm = () => {
  const radioButtons = document.querySelectorAll(".form-check-input.radio_buttons");
  const infoUnemployment = document.getElementById("info_unemployment_oui");
  if (infoUnemployment) {
    radioButtons.forEach((radioButton) => {
      radioButton.addEventListener('click', () => {
        const collapse = document.getElementById("collapse_section");
        if (infoUnemployment.checked) {
          collapse.classList.remove("d-none");
        } else {
          collapse.classList.add("d-none");
        }
      })
    })
    window.onload = () => {
      const collapse = document.getElementById("collapse_section");
      if (infoUnemployment.checked) {
        collapse.classList.remove("d-none");
      } else {
        collapse.classList.add("d-none");
      }
    }
  }
}

export { collaspeInfoForm }
