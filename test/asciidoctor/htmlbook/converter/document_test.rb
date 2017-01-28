require 'test_helper'

class Asciidoctor::Htmlbook::Converter::DocumentTest < ConverterTest
  def test_convert_document
    doc = <<~EOF
    EOF

    html = <<~EOF
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset=\"utf-8\" />
          <title></title>
        </head>
        <body data-type="book">
        </body>
      </html>
    EOF

    assert_equal_xhtml html, Asciidoctor.convert(doc, backend: 'htmlbook')
  end

  def test_convert_document_with_title
    doc = <<~EOF
      = Doc Title
    EOF

    html = <<~EOF
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset=\"utf-8\" />
          <title>Doc Title</title>
        </head>
        <body data-type="book">
        </body>
      </html>
    EOF

    assert_equal_xhtml html, Asciidoctor.convert(doc, backend: 'htmlbook')
  end
end
