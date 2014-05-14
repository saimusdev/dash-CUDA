# HTML parsing
require 'nokogiri'

# DB connection
require 'sqlite3'

task :default => [
  :create_docset,
  :download_docs,
  :parse_docs,
  :clean_docs,
  :import_docset,
  :clean
]

# Docset specific values
DOMAIN="nvidia.com"
DOCS_FOLDER="docs." << DOMAIN
DOCSET_NAME="CUDA"
COMPLETE_DOCS=[ 
      "http://docs.nvidia.com/cuda/cuda-runtime-api/" #,
#      "http://docs.nvidia.com/cuda/cuda-driver-api/",
#      "http://docs.nvidia.com/cuda/cuda-math-api/",
#      "http://docs.nvidia.com/cuda/cublas/",
#      "http://docs.nvidia.com/cuda/nvblas/",
#      "http://docs.nvidia.com/cuda/cufft/",
#      "http://docs.nvidia.com/cuda/curand/",
#      "http://docs.nvidia.com/cuda/cusparse/",
#      "http://docs.nvidia.com/cuda/npp/",
#      "http://docs.nvidia.com/cuda/thrust/"
]

task :create_docset do
  print_stdout "--> Creating the folder structure..."
  FileUtils.mkdir_p "#{DOCSET_NAME}.docset/Contents/Resources/Documents"
  FileUtils.cp %w(icon.png icon@2x.png), "#{DOCSET_NAME}.docset/"
end

task :download_docs do
  print_stdout "--> Downloading the documentation of '#{DOCSET_NAME}'..."
  COMPLETE_DOCS.each do |docs|
    print_stdout "--> Downloading '#{docs}'..."
    system "wget --recursive --page-requisites --adjust-extension --convert-links \
          --domains #{DOMAIN} --no-parent #{docs} 2>&1 | egrep -i '%|Saving to\'"
  end
end

task :parse_docs do
  print_stdout "--> Parsing the documentation for entries..."

end

task :clean_docs do
  print_stdout "--> Cleaning the documentation..."
  
end

task :import_docset do
  print_stdout "--> Importing the docset into Dash..."

end

task :clean do
  print_stdout "--> Cleaning..."
  #FileUtils.rm_rf "#{DOCS_FOLDER}"
end

# Auxiliar functions 
private
	def print_stderr(text); print "\e[31m#{text}\e[0m\n"; end
	def print_stdout(text); print "\e[32m#{text}\e[0m\n"; end

