class UpdateDeal {
  constructor(dealRow){
    this.dealRow = $(dealRow);
    this.dealId = dealRow.dataset.options;
    this.quantity = 0;
  }

  init() {
    setInterval(this.getDealQuantity(this), 5000);
  }

  getDealQuantity(deal) {
    deal_id = deal.dealId
    $.ajax({
      type: "GET",
      url: "/get_deal_quantity?id=" + deal_id,
      success: function(result){
        if (result['live'] && !result['quantity']){
          deal.dealRow.text('Sold Out')
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
