require 'test_helper'

class Asciidoctor::Htmlbook::Converter::VideoTest < ConverterTest
  def test_convert_video
    doc = <<~EOF
      video::video_file.mp4[]
    EOF

    html = <<~EOF
      <video src="video_file.mp4">
        <em>Sorry, the &lt;video&gt; element not supported in your reading system.</em>
      </video>
    EOF

    assert_convert_body html, doc
  end

  def test_convert_video_with_attributes
    doc = <<~EOF
      video::video_file.mp4[width=480, height=270, poster="video_poster.png"]
    EOF

    html = <<~EOF
      <video src="video_file.mp4" width="480" height="270" poster="video_poster.png">
        <em>Sorry, the &lt;video&gt; element not supported in your reading system.</em>
      </video>
    EOF

    assert_convert_body html, doc
  end
end
