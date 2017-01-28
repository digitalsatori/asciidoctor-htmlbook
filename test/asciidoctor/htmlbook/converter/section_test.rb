require 'test_helper'

class Asciidoctor::Htmlbook::Converter::SectionTest < ConverterTest
  def test_convert_section_part
    doc = <<~EOF
      = Book
      :doctype: book

      [[part]]
      = Part Title

      [[chapter]]
      == Chapter Title
    EOF

    html = <<~EOF
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset=\"utf-8\" />
          <title>Book</title>
        </head>
        <body data-type="book">
          <section id="part" data-type="part">
            <h1>Part Title</h1>
            <section id="chapter" data-type="chapter">
              <h1>Chapter Title</h1>
            </section>
          </section>
        </body>
      </html>
    EOF

    assert_equal_xhtml html, Asciidoctor.convert(doc, backend: 'htmlbook')
  end

  def test_convert_section_chapter
    doc = <<~EOF
      [[chapter]]
      == Chapter Title
    EOF

    html = <<~EOF
      <section id="chapter" data-type="chapter">
        <h1>Chapter Title</h1>
      </section>
    EOF

    assert_convert_equal html, doc
  end

  def test_convert_section_sect1
    doc = <<~EOF
      [[section]]
      === Section Title
    EOF

    html = <<~EOF
      <section id="section" data-type="sect1">
        <h1>Section Title</h1>
      </section>
    EOF

    assert_convert_equal html, doc
  end

  def test_convert_section_sect2
    doc = <<~EOF
      [[section]]
      ==== Section Title
    EOF

    html = <<~EOF
      <section id="section" data-type="sect2">
        <h2>Section Title</h2>
      </section>
    EOF

    assert_convert_equal html, doc
  end

  def test_convert_section_preface
    doc = <<~EOF
      [preface]
      [[preface]]
      == Preface Title
    EOF

    html = <<~EOF
      <section id="preface" data-type="preface">
        <h1>Preface Title</h1>
      </section>
    EOF

    assert_convert_equal html, doc
  end
end