require 'test_helper'
require 'rexml/document'

class Asciidoctor::Htmlbook::ConverterTest < Minitest::Test
  def setup
    @doc = Asciidoctor::Document.new nil, backend: 'htmlbook'
  end

  def test_convert_empty_document
    assert_equal_xhtml <<~EOF, @doc.convert
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
  end

  def test_convert_section_part
    section = Asciidoctor::Section.new @doc
    section.sectname = 'sect0'
    section.title = 'Part Title'
    section.id = "_part0"
    assert_equal_xhtml <<~EOF, section.convert
      <section id="_part0" data-type="part">
        <h1>Part Title</h1>
      </section>
    EOF
  end

  def test_convert_section_sect1
    section = Asciidoctor::Section.new @doc
    section.sectname = 'sect1'
    section.title = 'Chapter Title'
    section.id = "_chapter1"
    assert_equal_xhtml <<~EOF, section.convert
      <section id="_chapter1" data-type="chapter">
        <h1>Chapter Title</h1>
      </section>
    EOF
  end

  def test_convert_section_sect2
    section = Asciidoctor::Section.new @doc
    (1..5).each do |level|
      section.sectname = "sect#{level + 1}"
      section.title = 'Section Title'
      section.id = "_sect#{level}"
      assert_equal_xhtml <<~EOF, section.convert
        <section id="_sect#{level}" data-type="sect#{level}">
          <h#{level}>Section Title</h#{level}>
        </section>
      EOF
    end
  end

  def test_convert_section_preface
    section = Asciidoctor::Section.new @doc
    section.sectname = 'preface'
    section.title = 'Preface Title'
    section.id = '_preface'
    assert_equal_xhtml <<~EOF, section.convert
      <section id="_preface" data-type="preface">
        <h1>Preface Title</h1>
      </section>
    EOF
  end

  def test_convert_paragraph
    block = Asciidoctor::Block.new @doc, :paragraph, source: 'Text'
    assert_equal_xhtml <<~EOF, block.convert
      <p>Text</p>
    EOF
  end

  def test_convert_indexterm_visible
    inline = Asciidoctor::Inline.new @doc, :indexterm, 'term', type: :visible
    assert_equal_xhtml <<~EOF, inline.convert
      <a data-type="indexterm">term</a>
    EOF
  end

  def test_convert_indexterm_invisible
    inline = Asciidoctor::Inline.new @doc, :indexterm, nil, attributes: { 'terms' => ['primary', 'secondary', 'tertiary']}
    assert_equal_xhtml <<~EOF, inline.convert
      <a data-type="indexterm" data-primary="primary" data-secondary="secondary" data-tertiary="tertiary" />
    EOF
  end

  def test_convert_inline_quoted
    assert_equal_xhtml <<~EOF, Asciidoctor::Inline.new(@doc, :quoted, 'text', type: :emphasis).convert
      <em>text</em>
    EOF
    assert_equal_xhtml <<~EOF, Asciidoctor::Inline.new(@doc, :quoted, 'text', type: :strong).convert
      <strong>text</strong>
    EOF
    assert_equal_xhtml <<~EOF, Asciidoctor::Inline.new(@doc, :quoted, 'text', type: :monospaced).convert
      <code>text</code>
    EOF
    assert_equal_xhtml <<~EOF, Asciidoctor::Inline.new(@doc, :quoted, 'text', type: :superscript).convert
      <sup>text</sup>
    EOF
    assert_equal_xhtml <<~EOF, Asciidoctor::Inline.new(@doc, :quoted, 'text', type: :subscript).convert
      <sub>text</sub>
    EOF
    assert_equal_xhtml <<~EOF, Asciidoctor::Inline.new(@doc, :quoted, 'text', type: :double).convert
      &#8220;text&#8221;
    EOF
    assert_equal_xhtml <<~EOF, Asciidoctor::Inline.new(@doc, :quoted, 'text', type: :single).convert
      &#8216;text&#8217;
    EOF
    assert_equal_xhtml <<~EOF, Asciidoctor::Inline.new(@doc, :quoted, 'text', type: :mark).convert
      <mark>text</mark>
    EOF
    assert_equal_xhtml <<~EOF, Asciidoctor::Inline.new(@doc, :quoted, 'text', type: :asciimath).convert
      \\$text\\$
    EOF
    assert_equal_xhtml <<~EOF, Asciidoctor::Inline.new(@doc, :quoted, 'text', type: :latexmath).convert
      \\text\\
    EOF
  end

  def test_convert_image
    assert_equal_xhtml <<~EOF, Asciidoctor::Block.new(@doc, :image, attributes: { 'target' => 'http://example.com/logo.png'}).convert
      <figure>
        <img src="http://example.com/logo.png" />
      </figure>
    EOF

    assert_equal_xhtml <<~EOF, Asciidoctor::Block.new(@doc, :image, attributes: { 'target' => 'http://example.com/logo.png', 'alt' => 'logo', 'title' => 'Image Title'}).convert
      <figure>
        <img src="http://example.com/logo.png" alt="logo" />
        <figcaption>Image Title</figcaption>
      </figure>
    EOF
  end

  def assert_equal_xhtml(except, actual)
    assert_equal pretty_format(except), pretty_format(actual)
  end

  def pretty_format(html)
    out = ""
    REXML::Document.new(html).write(out, 2)
    out.gsub(/^\s*\n/, '')
  end
end
