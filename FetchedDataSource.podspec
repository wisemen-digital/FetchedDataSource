Pod::Spec.new do |s|
	# info
	s.name			= 'FetchedDataSource'
	s.version		= '1.0.0'
	s.summary		= 'Fetched results controller wrapper that allows joining multiple FRCs'
	s.description	= 'This framework provides fetched results controller subclasses for static data and joining multiple FRCs together into one.'
	s.homepage		= 'https://github.org/djbe/FetchedDataSource'
	s.license		= 'MIT'
	s.author		= { 'David Jennes' => 'david.jennes@gmail.com' }
	
	# configuration
	s.platform		= :ios, '8.0'
	
	# files
	s.frameworks	= 'Foundation', 'CoreData'
	s.source		= { :git => 'https://github.org/djbe/FetchedDataSource.git', :tag => "#{s.version}" }
	s.source_files	= 'Source/*.{swift}'
end
