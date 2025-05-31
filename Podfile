# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'Thrive Church Official App' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Thrive Church Official App
  pod 'Firebase/Core'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Analytics'
  pod 'Firebase/Messaging'
  pod 'FeedKit', '~> 9.0'

  target 'Thrive Church Official AppTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Thrive Church Official AppUITests' do
    inherit! :complete
    # Pods for testing
  end

end

# Force all pods to use iOS 15.0 minimum deployment target
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end
end