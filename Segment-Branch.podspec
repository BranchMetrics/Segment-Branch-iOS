Pod::Spec.new do |s|
  s.name             = "Segment-Branch"
  s.version          = "0.1.10"
  s.summary          = "Branch Integration for Analytics for iOS."

  s.description      = <<-DESC
                       Analytics for iOS provides a single API that lets you
                       integrate with 100s of tools.

                       With Branch's deep linking platform, mobile developers and marketers can leverage their app content to improve discoverability and optimize install campaigns.

                       This is the Branch integration for the Segment iOS library.
                       DESC

  s.homepage         = "https://github.com/BranchMetrics/Segment-Branch-iOS"
  s.license          = 'MIT'
  s.author           = { "Branch Metrics" => "support@branch.io" }
  s.source           = { :git => "https://github.com/BranchMetrics/Segment-Branch-iOS.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/branchmetrics'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  s.dependency 'Analytics'
  s.dependency 'Branch'
end
