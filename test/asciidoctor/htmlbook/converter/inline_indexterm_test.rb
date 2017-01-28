require 'test_helper'

class Asciidoctor::Htmlbook::Converter::InlineIndextermTest < ConverterTest
  def test_convert_inline_indexterm_visible
    doc = <<~EOF
      ((term))
    EOF

    html = <<~EOF
      <p>
        <a data-type="indexterm">term</a>
      </p>
    EOF

    assert_convert_equal html, doc
  end

  def test_convert_inline_indexterm_invisible
    doc = <<~EOF
      (((primary, secondary, tertiary)))
    EOF

    html = <<~EOF
      <p>
        <a data-type="indexterm" data-primary="primary" data-secondary="secondary" data-tertiary="tertiary" />
      </p>
    EOF

    assert_convert_equal html, doc
  end
end
