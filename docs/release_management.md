= Release Management =

This doco's just here as a checklist to refer to when making a release (because otherwise I'll inevitably get it wrong).

Steps:

 * Bump version in ```lib/guard/mocha_node/version.rb```
 * Ensure everything's committed
 * Ensure the desired release is all in master
 * Ensure [Travis CI](https://travis-ci.org/neerolyte/guard-mocha-node) is passing
 * Build the gem: ```gem build guard-mocha-node.gemspec```
 * Publish the gem: ```gem push %gem file we just made%```
 * Relax.
