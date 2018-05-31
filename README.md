# Chef JSON Formatter

## Build
```ruby
gem build json-chef-formatter.gemspec
```

TODO: Better Docs.
Build the gem then call chef with `-F json`

## Sample Output

```json
{
  "resources":[
    {
      "cookbook":"some-cookbook",
      "recipe":"default",
      "status":"failed"
    }
  ],
  "error":true,
  "error_msg":"file[] (some-cookbook::default line 20) had an error: Errno::ENOENT: No such file or directory @ rb_sysopen - ",
  "steps":[
    "Starting Chef Client, version 13.6.4",
    "Ohai Completed",
    "Registration Skipped",
    "Node data load started",
    "Node data load complete",
    "Cookbook resolution started: some-cookbook",
    "Cookbook resolution complete",
    "Cookbook cleanup started",
    "Cookbook cleanup complete",
    "Cookbook synchronize started",
    "Cookbook nuget synchronized",
    "Cookbook some-cookbook synchronized",
    "Cookbook synchronize complete",
    "Library loading started: 0",
    "File loaded: /Users/someone/cookbooks/some-cookbook/recipes/default.rb",
    "Recipe load complete",
    "Converge started: #<Chef::RunContext:0x00007f92e9512768>",
    "Executing create on file[]",
    "Executing create on file[] loaded file[]",
    "Executing create on file[] failed: No such file or directory @ rb_sysopen - ",
    "Handlers starting.  Count 0",
    "Handlers complete"
  ]
}
```