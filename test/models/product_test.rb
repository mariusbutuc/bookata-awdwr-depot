require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # Welcome to Marius' first experience with MiniTest
  #
  # 1. What to test?
  #
  #   if
  #     we create a product with no attributes set,
  #   we’ll expect it to
  #     be invalid and
  #     for there to be an error associated with each field.
  #
  # We can use the model’s `errors` and `invalid?` methods to see whether it
  # validates, and we can use the `any?` method of the error list to see whether
  # there is an error associated with a particular attribute.
  #
  # 2. How to tell the test framework whether our code passes or fails?
  #
  #   assertions
  #
  fixtures :products

  test 'product attributes must not be empty' do
    product = Product.new

    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test 'product price must be positive' do
    product = Product.new(
      title: 'My Book Title',
      description: 'yyy',
      image_url: 'zzz.jpg'
    )

    # worth breaking down into 3 different tests?
    product.price = -1
    assert product.invalid?
    assert_equal ['must be greater than or equal to 0.01'],
      product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ['must be greater than or equal to 0.01'],
      product.errors[:price]

    product.price = 1
    assert product.valid?
  end

  def new_product_with_image(image_url)
    Product.new(
      title: 'My Book Title',
      description: 'yyy',
      price: 1,
      image_url: image_url
    )
  end

  test 'image url accepts gif, jpg or png images' do
    valid_urls = %w{ fred.gif fred.jpg fred.png FRED.PNG Fred.Jpg
                     http://example.com/path/to/fred.gif }

    valid_urls.each do |img_url|
      # All of the testing assertions accept an optional trailing parameter
      # containing a string. This will be written along with the error message
      # if the assertion fails and can be useful for diagnosing what went wrong
      assert new_product_with_image(img_url).valid?, "#{img_url} should be valid"
    end
  end

  test 'image url does not accept any other files' do
    invalid_urls = %w{ fred.doc fred.gif/more fred.gif.more }

    invalid_urls.each do |img_url|
      assert new_product_with_image(img_url).invalid?,
        "#{img_url} should not be valid"
    end
  end

  test 'product is not valid without a unique title' do
    product = Product.new(
      title: products(:ruby).title,
      description: 'yyy',
      price: 1,
      image_url: 'fred.png'
    )

    assert product.invalid?
    # avoid using a hard-coded string for the Active Record error by comparing
    # the response against its built-in error message table
    assert_equal [I18n.translate('errors.messages.taken')],
      product.errors[:title]
  end

  test 'product is not valid with title less than 10 characters long' do
    title_too_short = '9 chr ttl'

    product = Product.new(
      title: title_too_short,
      description: 'yyy',
      price: 1,
      image_url: 'fred.png'
    )

    assert product.invalid?

    # OPTIMIZE How do I change parametrized error string to use I18n?
    #   * I18n.translate('errors.messages.too_short')
    assert_includes product.errors[:title],
      "an authentic title should really have more than just 10 characters, don't you think?"
  end

end
