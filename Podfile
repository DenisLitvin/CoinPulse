# Uncomment the next line to define a global platform for your project
platform :ios, '9.3'

target 'CoinPulse' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for CoinPulse
  pod 'Charts' 
  pod 'Kanna', '~> 2.1.0'
  pod 'OneSignal', '>= 2.5.2', '< 3.0'
  #pod 'Google-Mobile-Ads-SDK'
  pod 'AppsFlyerFramework'
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  
  
target 'OneSignalNotificationServiceExtension' do
   
   pod 'OneSignal', '>= 2.5.2', '< 3.0'
  end  
  
  
end

post_install do |installer|
        # Your list of targets here.
	myTargets = ['Kanna']
	
	installer.pods_project.targets.each do |target|
		if myTargets.include? target.name
			target.build_configurations.each do |config|
				config.build_settings['SWIFT_VERSION'] = '3.2'
			end
		end
	end
end
