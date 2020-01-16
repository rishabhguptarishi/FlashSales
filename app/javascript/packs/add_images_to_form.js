$('[data-image="add-more-images"]').on('click', function(event) {
  event.preventDefault();
  let node = $('[data-input-image="input_fields"]').clone();
  node.removeAttr('data-input-image');
  let inputNode = node.find('.file-input');
  inputNode.val('');
  parentNode = $('#imagesGroup');
  nodeNumber = parentNode.children().length - parentNode.find('img').length;
  inputNode.attr('name','deal[images_attributes]['+ nodeNumber +'][image]')
  inputNode.attr('id','deal_images_attributes_'+ nodeNumber +'_image')
  node.css('display', 'block')
  parentNode.append(node);
});
