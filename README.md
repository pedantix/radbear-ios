# radbear-ios
A library for creating an iOS app connected to a Ruby on Rails back end.

Here are some raw notes on how to set up a project. You can also check out our sample app here ___

* in xcode, create a new project
  * choose iOS, "Tabbed Application"
  * example on fields to fill in:
    * Product Name: rblast-ios
    * Org Name: Radical Bear LLC
    * Company id: com.radicalbear
    * Class Prefix: leave blank
    * Devices: either
 
* install pods
  * copy Podfile from recent project
    * comment out integration test stuff for now
  * pod install
   
* configure app
  * add Bundle display name to plist, give the app a name
  * add FontAwesome.ttf to plist (for BButton)
  * update AppDelegate from other project
  * add User model
  * copy and update Environment.plist
  * add Configuration key to plist
    * reference: http://blog.carbonfive.com/2011/06/20/managing-ios-configurations-per-environment-in-xcode-4/
  * set app's storyboard to RBMain.storyboard (only if using standard radbear auth)
    * doesn't seem to work w/o the .storyboard extension
    * also, change for all device types
  * lock the orientation to Portrait
    * until all the screens work in both
  * rename app's storyboard to AppMain
  * create TabBarViewController subclassed from RBTabBarViewController and assign icons
    * see pattern from other app
  * share scheme
    * so it is put into git
  * copy App Transport Security Settings from plist in other project
    * edit accordingly
  * copy the 2 NSLocation items from plist in other project
    * if using location features
  * .gitignore
    * copy from another project
            
* add settings to AppMain
  * add TabBarViewController class and set the class in the storyboard
    * should subclass RBTabViewController (copy from another project)
  * remove 2nd auto created vc
  * add a nav controller, link to tab controller
  * set the tab item title to "Settings"
  * set class of the table vc to RBSettingsViewController
  * set the cell to RBSimpleCell and CellIdentifier

* set up KIF test environment
  * follow install instructions
    * https://github.com/kif-framework/KIF/
    * name the test target integration-tests
    * uncomment the pod file section
  * to configure scheme to know if it's running test suite or not
    * add env var to run and test in scheme, running_kif_tests should be NO or YES respectively
  * copy test classes from another project
  * create a Web folder, add it but choose "Create folder references for any added folders"
  * try it, run Product -> Test

* set up build on circle ci
  * add project to circle
    * set experimental setting as ios app
    * it should fail at first
    * env vars
      * HOCKEYAPP_API_TOKEN = get from hockeyapp site
      * KEY_PASSWORD = foobar
  * set release code signing identity like other projects
  * copy circle.yml and scripts folder from another project
    * update as needed, get profile, etc
    * make sure xcode versions match between circle.yml and local dev
  * if production certificate is different, update dist.cer and dist.p12
    * open keychain access
    * in "My Certificates" find the certificate
      * matches DEVELOPER_NAME from circle.yml
    * expand it so it shows both the certificate and private key
    * export the certificate line as dist.cer
    * export the private key line as dist.p12
      * make the password "foobar"
    * save these 2 files into the /scripts folder
  * add ResourceRules
    * http://stackoverflow.com/questions/26497863/xcode-6-1-error-while-building-ipa/26499526#26499526
    * had to remove setting to submit to apple
      * http://stackoverflow.com/questions/32504355/error-itms-90339-this-bundle-is-invalid-the-info-plist-contains-an-invalid-ke
    * after this is resolved, update docs: https://www.groundswell.legal/tasks/5498
  * add contents of ~/.ssh/circle_read_write to circle project in "SSH Permissions" section
    * host name is github.com
    * for more info see: https://circleci.com/docs/adding-read-write-deployment-key
  * push to github
  * check build on circle

* set up crash reporting w/ new relic
  * add steps here

* configure Facebook (optional)
  * create FB app
    * enable Native iOS App
    * fill in bundle id and enable FB login
    * take FB app out of sandbox mode, else app id will not be valid to other non developer users
  * add to plist (copy from other project and update)
    * URL types
    * FacebookAppID
    * FacebookDisplayName
    * LSApplicationQueriesSchemes
    * AppTransportSecuritySettings
      (facebook, fbcdn, akamaihd)