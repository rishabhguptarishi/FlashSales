class Slideshow {

  constructor($slideshowArea) {
    this.$slideItems = $slideshowArea.find('li');
    this.slideShowSize = this.$slideItems.length;
    this.$slideshowArea = $slideshowArea;
    this.nextItem = 0;
    //this.$navigation = $('<div />', {'class': 'navigation',});
    this.init();
  }

  init() {
    //this.$slideshowArea.prependTo('body');
    //this.$navigation.addClass('navigationArea').insertAfter(this.$slideshowArea);
    this.beginSlideshow();
  }

  beginSlideshow() {
    let $items = this.$slideItems.slice(0,1);
    $items.siblings().addClass('hidden');
    //this.$navigation.html(`${this.nextItem + 1} of ${this.slideShowSize}... Image: ${this.showImageViewed()}`);
    $items.delay(3500).fadeOut(500, () => {
        this.showNextSlideItem();
      });
  }

  showNextSlideItem() {
    this.nextItem += 1;
    this.resetNextItemIfOverflow();
    //this.$navigation.html(`${this.nextItem + 1} of ${this.slideShowSize} --> Image: ${this.showImageViewed()}`);
    this.revealSlideItem();
  }

  revealSlideItem() {
    this.$slideItems.eq(this.nextItem).fadeIn(500).delay(3000).fadeOut(500, () => {
        this.showNextSlideItem();
      });
  }

  resetNextItemIfOverflow() {
    if (this.nextItem === this.slideShowSize) {
      this.nextItem = 0;
    }
  }
}

$(() => {
  let $slideshowArea = $('[data-slideshow]');
  $slideshowArea.each( function(index, value){
    new Slideshow($(value));
  });
  //new Slideshow($slideshowArea);
});
