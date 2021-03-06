Pod::Spec.new do |s|
    s.name             = "CocoaBloc-Camera"
    s.version          = "0.1.7"
    s.summary          = "StageBloc's iOS camera components"
    s.description      = "An iOS UI framework for StageBloc photo/video composition"
    s.homepage         = "https://github.com/stagebloc/CocoaBloc-Camera"

    s.license = { :type => 'MIT', :file => 'LICENSE' }
    s.authors = {   'John Heaton'   => 'pikachu@stagebloc.com',
                    'Mark Glagola'  => 'mark@stagebloc.com',
                    'David Warner'  => 'spiderman@stagebloc.com',
                    'Josh Holat'    => 'bumblebee@stagebloc.com' }
    s.source  = { :git => "https://github.com/stagebloc/CocoaBloc-Camera.git", :tag => s.version.to_s }
    s.social_media_url = 'https://twitter.com/stagebloc'

    s.platform     = :ios, '7.0'
    s.requires_arc = true

    s.dependency 'pop', '~> 1.0'
    s.dependency 'ReactiveCocoa', '~> 2.0'
    s.dependency 'PureLayout', '~> 2.0'

    s.dependency 'CocoaBloc-UI', '~> 0.0.3'

    s.source_files = 'Pod/Classes/**/*'
    s.private_header_files = "Pod/Classes/Misc/*.h"
    s.resources = ['Pod/Assets/*']

end
