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
- [x] use SSL-enabled profile images `profile_image_url_https`

#### Prototype cell
- [x] clip profile image radius
- [ ] consider using `nameLabel.preferredMaxLayoutWidth` hack
- [ ] add user handle label
- [ ] add timestamp label
- [ ] add "explanation" label

#### Tweet Details screen
- [ ] add `TweetDetailViewController` for tweet detail
- [ ] layout TweetDetail controls
- [ ] add support for favorite
- [ ] add support for retweet
- [ ] add support for reply
