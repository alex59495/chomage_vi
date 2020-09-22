const scrollDelete = () => {
  if (document.getElementById('iconDelete')) {
    document.getElementById('iconDelete').addEventListener(('click'), (e) => {
      window.scrollTo(0,document.body.scrollHeight);
    })
  }
}

export default scrollDelete