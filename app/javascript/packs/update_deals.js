class UpdateDeal {
  constructor(dealRow){
    this.dealRow = $(dealRow);
    this.dealId = dealRow.dataset.options;
    this.url = dealRow.dataset.url
    this.quantity = 0;
    this.getDealQuantity = this.getDealQuantity.bind(this);
  }

  init() {
    setInterval(this.getDealQuantity, 5000);
  }

  getDealQuantity() {
    $.ajax({
      type: "GET",
      url: this.url,
      success: function(result){
        if (result['live'] && !result['quantity_available']){
          this.dealRow.text('Sold Out')
        }
      },
      error: function(result){alert("Some Error Occurred")}
    });
  }
}
$(() => {
  $('[data-options]').each(function(index, value){
    new UpdateDeal(value).init();
  });
});
