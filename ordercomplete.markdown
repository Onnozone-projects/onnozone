---
layout: page
title: Order complete
permalink: /ordercomplete/
sitemap: false
---

You will get updates about the progress of this order via e-mail.

Shipping details:

<script>
    (function(){
        function getUrlParameter(name) {
            name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
            var regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
            var results = regex.exec(location.search);
            return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
        };
        var orderId = getUrlParameter('order');
        var order = JSON.parse(sessionStorage.getItem(orderId));
        if (!order) {
            location.assign('{{ site.url }}');
        }
        var shipping = order.purchase_units.pop().shipping;
        var address = shipping.address;
        var details = [];
        if (address.address_line_1) details.push(address.address_line_1);
        if (address.address_line_2) details.push(address.address_line_2);
        if (address.postal_code) details.push(address.postal_code);
        if (address.admin_area_2) details.push(address.admin_area_2);
        if (address.admin_area_1) details.push(address.admin_area_1);
        if (address.country_code) details.push(address.country_code);
        document.write([details.join(', '), shipping.name.full_name].join('<br/>'));
    })();
</script>
