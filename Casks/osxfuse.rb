cask 'osxfuse' do
  version '3.5.2'
  sha256 '49ed3b3cf015cd9ca113de901a57cbd2cd8f4b5afe93259c10b5fddc7256f947'

  # github.com/osxfuse was verified as official when first introduced to the cask
  url "https://github.com/osxfuse/osxfuse/releases/download/osxfuse-#{version}/osxfuse-#{version}.dmg"
  appcast 'https://github.com/osxfuse/osxfuse/releases.atom',
          checkpoint: 'ed33e42fda060f052c775c50ae90068065dead115f27eb7c5709c02082007643'
  name 'OSXFUSE'
  homepage 'https://osxfuse.github.io/'
  license :bsd

  installer script: '/usr/sbin/installer',
            args:   [
                      '-pkg', "#{staged_path}/Extras/FUSE for macOS #{version}.pkg",
                      '-target', '/',
                      '-applyChoiceChangesXML', "#{staged_path}/Extras/Choices.xml"
                    ]

  preflight do
    IO.write "#{staged_path}/Extras/Choices.xml", <<-EOS.undent
      <plist>
        <array>
        	<dict>
        		<key>attributeSetting</key>
        		<integer>1</integer>
        		<key>choiceAttribute</key>
        		<string>selected</string>
        		<key>choiceIdentifier</key>
        		<string>com.github.osxfuse.pkg.MacFUSE</string>
        	</dict>
        </array>
      </plist>
    EOS
  end

  postflight do
    set_ownership ['/usr/local/include', '/usr/local/lib']
  end

  uninstall pkgutil: [
                       'com.github.osxfuse.pkg.Core',
                       'com.github.osxfuse.pkg.MacFUSE',
                       'com.github.osxfuse.pkg.PrefPane',
                     ],
            kext:    'com.github.osxfuse.filesystems.osxfusefs'

  caveats do
    reboot
  end
end
