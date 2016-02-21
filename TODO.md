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

#### Home Timeline
- [x] add `UITableView` for initial set of tweets
- [x] add ATS Exception for `pbs.twimg.com`
- [x] add custom `TweetCell` as prototype cell for tableView
- [x] add support for pullToRefresh
- [x] change navbar color theme (is this across entire app or vc by vc?)
- [x] use SSL-enabled profile images `profile_image_url_https`
- [ ] debug intermittent `kCFStreamErrorDomainSSL, -9802` SSL certificate error

#### Prototype cell
- [x] clip profile image radius
- [x] add user handle label
- [x] add timestamp label
- [ ] add "explanation" label
- [ ] calculate relative timestamp string
- [ ] consider using `nameLabel.preferredMaxLayoutWidth` hack

#### Tweet Details screen
- [x] add `TweetDetailViewController` for tweet detail
- [x] layout TweetDetail controls
- [x] add image assets (`.png` instead of `.svg` - why doesn't iOS like SVG?)
- [x] add retweet and favorite counts
- [ ] debug why `favourites_count` is always 0
- [ ] add support for favorite
- [ ] add support for retweet
- [ ] add support for reply

#### Compose Tweet screen
- [ ] add `TweetComposeViewController` for posting tweet
- [ ] layout TweetCompose screen
- [ ] present screen modally
- [ ] wire up posting tweet
