pdf_dir = "#{Rails.root}/tmp/pdfs/"
FileUtils.mkdir_p(pdf_dir) unless File.directory?(pdf_dir)
