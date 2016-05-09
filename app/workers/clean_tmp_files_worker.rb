class CleanTmpFilesWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false, unique: :until_executed

  def perform
    clean_pdfs
  end

  def clean_pdfs
    Dir.glob("tmp/pdfs/*.{pdf}").each { |file|
      File.delete(file) if Time.now - File.mtime(file) > 600
    }
  end
end
