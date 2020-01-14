document.querySelector('[data-image]').addEventListener('click', function(event) {
  event.preventDefault();
  let node = document.getElementById('imageInput').cloneNode(true);
  node.removeAttribute('id')
  document.getElementById('imagesGroup').appendChild(node);
});
