require 'securerandom'

module Jekyll
  class PaypalButtonTag < Liquid::Tag
    def initialize(tag_name, input, tokens)
      super
      @tag_id = SecureRandom.hex(4)
      inputList = input.split("|")
      @itemName = inputList[0].strip
      @itemSku = inputList[1].strip
      @itemValue = inputList[2].strip
      @itemDescription = inputList[3].strip
      @currencyCode = Jekyll.configuration({})['currency_code']
    end

    def render(context)
      %Q[
<div id="paypal-#{@tag_id}" class="paypal-button"></div>
<script>
(function(){
  function onFail() {
    location.reload();
  };
  paypal.Buttons({
    style: { shape:   'pill' },
    createOrder: function(data, actions) {
      return actions.order.create({
        purchase_units: [{
          amount: {
            value: '#{@itemValue}', currency_code: '#{@currencyCode}',
            breakdown: { item_total: { value: '#{@itemValue}', currency_code: '#{@currencyCode}' }}
          },
          description: '#{@itemName}',
          items: [{
            name: '#{@itemName}',
            unit_amount: { value: '#{@itemValue}', currency_code: '#{@currencyCode}' },
            quantity: '1',
            sku: '#{@itemSku}',
            description: '#{@itemDescription}',
            category: 'PHYSICAL_GOODS'
          }]
        }]
      });
    },
    onApprove: function (data, actions) {
      document.querySelector('#paypal-#{@tag_id}').classList.add('processing');
      return actions.order.capture().then(function(details) {
        sessionStorage.setItem(details.id, JSON.stringify(details))
        location.assign('/ordercomplete?order=' + details.id);
      });
    },
    onCancel: onFail,
    onError: onFail
  }).render('#paypal-#{@tag_id}');
})();
</script>
      ]
    end
  end
end

Liquid::Template.register_tag("paypalbutton", Jekyll::PaypalButtonTag)
