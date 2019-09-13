# logstash-rspec

This is a docker image to run rspecs, testing [logstash](https://www.google.de/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=2ahUKEwjf2cq34c3kAhWRKewKHcGoBTwQFjAAegQIBBAB&url=https%3A%2F%2Fwww.elastic.co%2Fde%2Fproducts%2Flogstash&usg=AOvVaw0RWvJF5fgaj8a_-EDUyneT) filter configurations. I wrote this image because [rspec is no longer bundled into production release](https://github.com/elastic/logstash/issues/6479) of logstash. Although there are some existing solutions to test logstash filter logic I didn't find one providing BDD testing DSL like rspec [used in core logstash development](https://github.com/elastic/logstash#testing) does.

## How to use this image

You may use the image to run a container as an executable which runs your rspec files against your filter configuration files:

        docker run --rm --name logstash-rspecs \
            -v <your-filter-folder>:/opt/logstash/filters-under-test \
            -v <your-rspec-folder>:/opt/logstash/rspec-tests  \
            iteratec/logstash-rspec:7.3.0

Examples of rspec tests may be found [in logstash project](https://github.com/elastic/logstash/tree/master/spec) itself or in [this blogpost](https://gquintana.github.io/2016/09/07/Testing-Logstash-configuration.html). Respective the examples within the latter, one will have to reference the filter config file to test, within mounted volume under `optlogstashfilters-under-test`:

        @@configuration << File.read("/opt/logstash/filters-under-test/<your-filter-conf-to-test>")

The image contains logstash sources and rspec tools/helpers as if one would develop logstash. The tag of this image corresponds to logstash release version.

It may be used locally or on a CI/CD server.

## Downside

The image is currently quite huge what might be a burden on a CI server. I am more a logstash user than a developer. So if anybody has more insights about what is really necessary (and what's not) to run rspec tests: Using a multi-stage docker build to decrease image size would be a very nice PR ;) . In the github repo there is also a variant using an alpine-jdk base image. But that one doesn't work so far and I don't have the time right now to investigate.