module InlineSVG

  def inline_svg(path)
    file = File.open("source/images/#{path}", "rb")
    file.read
  end

end
