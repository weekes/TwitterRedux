## TODO

#### Refactor Twitter (Project 3)
- [x] Tag last week's project
- [x] Switch from dynamic frameworks to bridging header file
- [x] Switch `User` struct from `NSDictionary` access to SwiftyJSON
- [x] Fix profile images by adding ATS exception on Twitter's SHA-1 cert
- [ ] Review Project 3 Feedback Guide

#### Custom container view
- [x] Add basic container view
- [x] Wire up `LoginViewController` as initial contentView
- [ ] Address "Presenting view controllers on detached view controllers is discouraged" on sign out dialog
- [ ] Add `tabBarItem` like functionality? or "2-way street" pattern? (pass hamburgerMenu in constructor?)

#### Hamburger ViewController
- [x] Dragging anywhere in the view should review the menu
- [x] Look at other Hamburger menu apps: Slack, Uber, Google Inbox, Google Calendar

#### Menu ViewController
- [x] Remove separators on unused rows
- [x] Switch to tableView group style and sections
- [x] Move "Sign out" from `TweetViewController` to `MenuViewController` (i.e. "hamburger menu")
- [ ] (*optional*) Customize with profile pic?

#### TweetViewController *(Home timeline)*
- [x] Set navbar title based on `TimelineType`
- [x] User icon for "Compose" button
- [ ] Fix windowing on Pull To Refresh
- [ ] Update `ComposeTweetViewController` to use delegate pattern back to `TweetViewController`

#### Profile ViewController
- [ ] Remove unused `ProfileViewController`
- [ ] Reuse TimelineViewController with profile header?
- [ ] Contains user header view (and image)
- [ ] Contains a section with the user's basic stats: # tweets, # following, # followers

#### Mentions timeline
- [x] Reuse `TweetViewController` for mentions
- [x] Fix date display when > 6 days (don't include time)
- [ ] Remove unused `MentionsViewController`

#### TweetCell
- [ ] properly display retweets (avatar, retweeted by, etc.)
- [ ] (*optional*) display links
- [ ] (*optional*) have links open WebView
- [ ] (*optional*) display hashtags
- [ ] (*optional*) hashtags link to search results TweetViewController
- [ ] (*optional*) inline media
