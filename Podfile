# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

target 'ChatApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ChatApp

  pod 'Firebase/Firestore', '~> 7.8'
  pod 'SwiftLint'

  # ignore all warnings from all dependencies
  inhibit_all_warnings!

  target 'ChatAppTests' do
    inherit! :search_paths
  end
  
  target 'ChatAppUITests' do
    inherit! :search_paths
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
