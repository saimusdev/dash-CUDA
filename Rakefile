# HTML parsing
require 'nokogiri'

# DB connection
require 'sqlite3'

task :default => [
  :create_docset,
  :download_docs,
  :create_plist,
  :create_db,
  #:parse_docs,
  :clean_docs,
  #:import_docset,
  #:clean
]

# Docset specific variables
DOMAIN="nvidia.com"
DOCS_FOLDER="docs." << DOMAIN
DOCSET_NAME="CUDA"
DOCSET_FOLDER="#{DOCSET_NAME}.docset"
DOCSET_DOCS_SUBFOLDER="#{DOCSET_FOLDER}/Contents/Resources/Documents"
PLIST_FILE="#{DOCSET_FOLDER}/Contents/Info.plist"
COMPLETE_DOCS=[
	[ # API documentation 
	"docs.nvidia.com/cuda/cuda-runtime-api/",
	"docs.nvidia.com/cuda/cuda-driver-api/",
	"docs.nvidia.com/cuda/cuda-math-api/",
	"docs.nvidia.com/cuda/cublas/index.html/",
	"docs.nvidia.com/cuda/nvblas/index.html/",
	"docs.nvidia.com/cuda/cufft/index.html/",
	"docs.nvidia.com/cuda/curand/index.html/",
	"docs.nvidia.com/cuda/cusparse/index.html/",
	#"docs.nvidia.com/cuda/npp/", # Currently only in PDF formatting
	], 
	[ # Guides 
	"docs.nvidia.com/cuda/nvrtc/index.html",
	"docs.nvidia.com/cuda/thrust/index.html",
	"docs.nvidia.com/cuda/cusolver/index.html",
	"docs.nvidia.com/cuda/cuda-c-programming-guide/index.html",
	"docs.nvidia.com/cuda/cuda-c-best-practices-guide/index.html",
	"docs.nvidia.com/cuda/maxwell-compatibility-guide/index.html",
	"docs.nvidia.com/cuda/kepler-tuning-guide/index.html",
	"docs.nvidia.com/cuda/maxwell-tuning-guide/index.html",
	"docs.nvidia.com/cuda/parallel-thread-execution/index.html",
	"docs.nvidia.com/cuda/optimus-developer-guide/index.html",
	"docs.nvidia.com/cuda/video-decoder/index.html",
	"docs.nvidia.com/cuda/inline-ptx-assembly/index.html"
	]
]
UNNECESARY_HTML_NODES=[
	"/html/body/header[@id='header']",
	"/html/body/div[@id='site-content']/nav[@id='site-nav']",
	"/html/body/div[@id='site-content']/div[@id='resize-nav']",
	"/html/body/div[@id='site-content']/nav[@id='search-results']",
	"/html/body/div[@id='site-content']/div[@id='contents-container']/div[@id='breadcrumbs-container']",
	"/html/body/div[@id='site-content']/div[@id='contents-container']/article[@id='contents']/div[@class='topic']/h2[@class='topictitle2']",
	"/html/body/div[@id='site-content']/div[@id='contents-container']/article[@id='contents']/div[@class='topic']/h3[@class='fake_sectiontitle']",
	"/html/body/div[@id='site-content']/div[@id='contents-container']/article[@id='contents']/hr[@id='contents-end']",
	"/html/body//script",
	"/html/body/div[@id='stcpDiv']",
	"/html/body/iframe[@id='stSegmentFrame']",
	"/html/body/div[@id='stwrapper']",
	"/html/body/div[@id='stOverlay']"
]
UNNECESARY_FILES=[
	"docs.nvidia.com/robots.txt",
	"docs.nvidia.com/cuda/search",
	"docs.nvidia.com/cuda/common/scripts",
	"docs.nvidia.com/cuda/common/formatting/*.js",
]
UPDATED_STYLES=[
	# First element: Stylesheet (file)
	["docs.nvidia.com/cuda/common/formatting/site.css", 
		# Second element: List of updated styles
		[
'#site-content { 
	position:fixed; 
	top: 0px; bottom:0; left:0; right:0;
	border:0px;
}'
		]
	]
]

# CREATE THE DOCSET FOLDER
task :create_docset do
    print_stdout "--> Creating folder structure..."
    if File.directory? DOCSET_FOLDER 
        FileUtils.rm_rf  DOCSET_FOLDER
    end
    FileUtils.mkdir_p DOCSET_DOCS_SUBFOLDER
    FileUtils.cp %w(icon.png icon@2x.png), "#{DOCSET_NAME}.docset/"
end

# DOWNLOAD THE DOCUMENTATION
task :download_docs do
    print_stdout "--> Downloading the documentation for #{DOCSET_NAME}..."
    COMPLETE_DOCS.each do |all_docs|
    	all_docs.each do |some_docs|
	        print_stdout "--> Downloading from 'http://#{some_docs}'..."
	        system "wget --recursive --page-requisites --adjust-extension --convert-links \
	                --domains #{DOMAIN} --no-parent http://#{some_docs} 2>&1 | egrep -i '%|Saving to\'"
	        FileUtils.cp_r(some_docs,"#{DOCSET_NAME}.docset/Contents/Resources/Documents")
	        #FileUtils.mv(some_docs,"#{DOCSET_NAME}.docset/Contents/Resources/Documents")
    	end
    end
end

# CREATE THE PROPERTY LIST
task :create_plist do
    print_stdout "--> Creating a Property List..."
    tab_space = ""
    4.times { tab_space <<= " " }

    plist_file = File.new(PLIST_FILE, 'w')
    plist_file.puts "<?xml version='1.0' encoding='UTF-8'?>\n" \
        << "<!DOCTYPE plist PUBLIC '-//Apple//DTD PLIST 1.0//EN' 'http://www.apple.com/DTDs/PropertyList-1.0.dtd'>\n" \
        << "<plist version='1.0'>\n" \
        << "<dict>\n" \
        << tab_space << "<key>CFBundleIdentifier</key>\n" \
        << tab_space << "<string>#{DOCSET_NAME}</string>\n" \
        << tab_space << "<key>CFBundleName</key>\n" \
        << tab_space << "<string>#{DOCSET_NAME}</string>\n" \
        << tab_space << "<key>DocSetPlatformFamily</key>\n" \
        << tab_space << "<string>#{DOCSET_NAME}</string>\n" \
        << tab_space << "<key>isDashDocset</key>\n" \
        << tab_space << "<true/>\n" \
        << tab_space << "<key>dashIndexFilePath</key>\n" \
        << tab_space << "<string>index.html</string>\n" \
        << tab_space << "<key>DashDocSetFamily</key>\n" \
        << tab_space << "<string>dashtoc</string>\n" \
        << tab_space << "<key>isJavaScriptEnabled</key>>\n" \
        << tab_space << "<true/>\n" \
        << "</dict>\n" \
        << "</plist>\n"
    plist_file.close
end

# CREATE THE DATABASE
task :create_db do
    print_stdout "--> Creating a Database to index documentation..."
   	db = SQLite3::Database.new "#{DOCSET_NAME}.docset/Contents/Resources/docSet.dsidx" 
   	db.execute "CREATE TABLE searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);"
   	db.execute "CREATE UNIQUE INDEX anchor ON searchIndex (name, type, path);"
end


task :parse_docs do
  print_stdout "--> Parsing the documentation for entries..."
end

# CLEAN THE DOCUMENTATION AND REMOVE UNNECESARY FILES
task :clean_docs do
 	print_stdout "--> Cleaning the documentation for better visualization..."
 	if File.directory? DOCS_FOLDER
	 	COMPLETE_DOCS.each do |all_docs|
		    all_docs.each do |some_docs|	
				html_docs = []
				get_files(some_docs, html_docs)
				html_docs.each do |doc_path|
					print "Cleaning: '#{doc_path}'\n"
					rewrite_html(doc_path)
				end
				remove_unnecessaries
				update_css
			end
		end
	else
		print_stderr "Need to download the documentation before cleaning it!"
	end
end

task :import_docset do
  print_stdout "--> Importing the docset into Dash..."

end

task :clean do
  print_stdout "--> Cleaning..."
  if File.directory? DOCS_FOLDER
    FileUtils.rm_rf  DOCS_FOLDER
  end
end

# Auxiliar functions 
private
	EXCLUDED_FILES = ['.', '..', 'index.html', '.DS_Store']; 
	EXCLUDED_EXTENSIONS = ['txt','js','css','ico','png','svg','png','jpg'];

	CLASS = "Class"
	CONSTANT = "Constant"
	GUIDE = "Guide"
	METHOD = "Method"

	num_classes = 0
	num_constants = 0
	num_guides = 0
	num_methods = 0

	# Return all files (including subdirectories) contained in path
	def get_files (path, files_found) 
		if File.directory? path
			Dir.foreach path do |file| 
				if (!EXCLUDED_FILES.include? file)
					get_files(path+file, files_found) 
				end
			end
		elsif File.file? path
			files_found << path
		end
	end

	# Remove all unnecessary nodes from html_file
	def rewrite_html (html_file)
		doc = Nokogiri::HTML(open(html_file))
		UNNECESARY_HTML_NODES.each do |node_path|
        	node = doc.xpath(node_path)
        	node.remove
   		end
   		File.open(html_file,'w') { |file| doc.write_html_to file }
	end 

	# Add updated styles to stylesheets
	def update_css ()
		UPDATED_STYLES.each do |rules|
			File.open(rules[0],'a') do |file| 
				rules[1].each { |rule| file.puts rule<<"\n" }
   			end
		end
	end

	# Remove unnecessary files (*.js,...)
	def remove_unnecessaries ()
		UNNECESARY_FILES.each do |file|
        	Dir.glob(file).each { |f| FileUtils.rm_rf f }
   		end
	end

	def print_stderr(text); print "\e[31m#{text}\e[0m\n"; end
	def print_stdout(text); print "\e[32m#{text}\e[0m\n"; end




