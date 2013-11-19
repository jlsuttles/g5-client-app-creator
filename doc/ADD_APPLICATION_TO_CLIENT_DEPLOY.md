# Add Application to Client Deploy

1. Add application definition config to `config/app_definitions.yml.erb` in
   g5-configurator. [See there for instructions.](http://github.com/g5search/g5-configurator/docs/ADD_APPLICATION_TO_CLIENT_DEPLOY.md)

2. Add application deployment config to `config/defaults.yml` in
   g5-client-app-creator. Example:

```yaml
    cpns:
      config:
        - "SECRET_TOKEN"
      tasks:
        - "rake db:migrate"
        - "rake deploy:tasks"
      addons:
        - "redistogo:nano"
        - "rediscloud:20"
        - "papertrail:choklad"
```

Note: The application needs to be restarted after this addition.
