$(document).on('ajax:success', function(event){
  if(event.detail[0]){
    alert("This deal is publishable and can be published");
  }
  else {
    alert("This deal is not publishable");
  }
});

$(document).on('ajax:error', function(response){
  alert("Unable to check publishability right now. Please try again later")
});
