module HtmlHelper
  def strip_html(html)
    strip_surrounding_whitespace substitute_entities strip_tags add_linebreaks html
  end

  def substitute_entities(html)
    html.andand.gsub(/&nbsp;/i, ' ').andand.gsub(/&amp;/i, '&')
  end

  def add_linebreaks(html)
    # I know Cthulu is coming for me. Forgive me.
    # http://stackoverflow.com/a/1732454/2720566
    html.
      andand.gsub(/<\/h[^>]>|<\/p>|<\/div>/, "\\1\n\n").
      andand.gsub(/<br[^>]*>/, "\\1\n")
  end

  def strip_surrounding_whitespace(html)
    html.andand.strip
  end

  def supplied_products_quantity(items)
    items.map(&:quantity).sum
  end

  def get_customer_name(customer)
    Customer.find_by_email(customer).try(:name)
  end

  def get_display_amount(item)
    item.display_amount_with_adjustments.money.to_f
  end

  def get_product_unit
    {'weight' => {1.0=> 'oz',16.0=> 'lb'}, 'volume'=> {1.0=> 'fl oz', 16.0=> 'pt', 128.0=> 'gal'}}
  end
end
