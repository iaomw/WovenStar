Pod::Spec.new do |s|

	s.name					= 'WovenStar'
	s.version				= '0.1'
	s.summary				= 'Another loading style animation.'
	s.homepage				= 'https://github.com/iaomw/WovenStar'
	s.license				= 'MIT'

	s.author			= { 'Sandy Lee' => 'iaomw@live.com' }

	s.source				= { :git => 'https://github.com/iaomw/WovenStar.git', :tag => s.version.to_s }

	s.requires_arc			= true
	s.platform				= :ios, '7.0'	
	s.source_files			= 'WovenStar/essence/*.{h,m}'
	s.frameworks			= 'QuartzCore', 'CoreGraphics'

end
