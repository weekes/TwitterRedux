## TODO

**REMOVE** this section before submitting

#### Basic OAuth Walkthrough
- [x] Create Twitter application on `dev.twitter.com`
- [x] Create Xcode workspace with `AFNetworking` and `BDBOAuth1Manager` pods
- [x] Set up Objective-C bridging header file (mixed Objective-C and Swift project)
- [x] NOTE for Optional tasks (spent a bunch of time upgrading to `AFNetworking 3.0`)
- [x] Complete OAuth dance, fetch user and timeline (20 tweets)

#### Refactor OAuth
- [x] Set up login method
- [x] switch `Tweet` and `User` data models to `struct` instead of `class`
- [x] embed `TweetsViewController` timeline in `UINavigationController`
- [x] add `UIAlertController` for logout confirmation
- [x] switch to `.Alert` style `UIAlertController` for logout confirmation
- [x] *Optional* use official Login with Twitter button?
- [ ] add a label with explanatory text on login screen

#### Home Timeline
- [x] add `UITableView` for initial set of tweets
- [x] add ATS Exception for `pbs.twimg.com`
- [x] add custom `TweetCell` as prototype cell for tableView
- [x] add support for pullToRefresh
- [x] change navbar color theme (is this across entire app or vc by vc? RGB=85,172,238, HEX #55ACEE)
- [x] use SSL-enabled profile images `profile_image_url_https`
- [ ] **debug** intermittent `kCFStreamErrorDomainSSL, -9802` SSL certificate error

#### Prototype cell
- [x] clip profile image radius
- [x] add user handle label
- [x] add timestamp label
- [x] calculate relative timestamp string (1m-59m, 1h-23h, 1d-6d, MM/DD/YY)
- [ ] add "explanation" label
- [ ] consider using `nameLabel.preferredMaxLayoutWidth` hack

#### Tweet Details screen
- [x] add `TweetDetailViewController` for tweet detail
- [x] layout TweetDetail controls
- [x] add image assets (`.png` instead of `.svg` - why doesn't iOS like SVG?)
- [x] add retweet and favorite counts
- [x] **debug** why `favourites_count` is always 0
- [x] add support for favorite
- [x] add support for retweet
- [x] immediately update state for like and retweet buttons
- [ ] add support for reply

#### Compose Tweet screen
- [x] add `ComposeTweetViewController` for posting tweet
- [x] layout ComposeTweet screen
- [x] present screen modally
- [x] change navbar background color and text color (HEX #55ACEE)
- [x] wire up posting tweet
